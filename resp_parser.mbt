///|
/// Byte-level RESP2 framing shared by the socket reader and `parse_redis_response`.
/// A RESP frame counts bytes, never characters, so all of this walks `Bytes`.

///|
fn decode_span(data : Bytes, start : Int, end : Int) -> String {
  @encoding/utf8.decode_lossy(data[start:end])
}

///|
fn parse_int_opt(text : String) -> Int? {
  Some(@string.parse_int(text)) catch {
    _ => None
  }
}

///|
fn find_crlf(data : Bytes, start : Int) -> Int? {
  let n = data.length()
  let mut i = start
  while i + 1 < n {
    if data[i] == b'\r' && data[i + 1] == b'\n' {
      return Some(i)
    }
    i = i + 1
  }
  None
}

///|
/// One CRLF-terminated line: its text without the terminator, and the offset just
/// past the terminator.
fn line_at(data : Bytes, start : Int) -> (String, Int)? {
  match find_crlf(data, start) {
    None => None
    Some(i) => Some((decode_span(data, start, i), i + 2))
  }
}

///|
fn parse_bulk_at(
  data : Bytes,
  len_text : String,
  after : Int,
) -> (RedisValue, Int)? {
  match parse_int_opt(len_text) {
    None => Some((Error("Invalid bulk length: " + len_text), after))
    Some(len) =>
      if len < 0 {
        Some((BulkString(None), after))
      } else if data.length() < after + len + 2 {
        None
      } else {
        Some(
          (
            BulkString(Some(decode_span(data, after, after + len))),
            after + len + 2,
          ),
        )
      }
  }
}

///|
fn parse_array_at(
  data : Bytes,
  count_text : String,
  after : Int,
) -> (RedisValue, Int)? {
  match parse_int_opt(count_text) {
    None => Some((Error("Invalid array count: " + count_text), after))
    Some(count) =>
      if count < 0 {
        Some((Array([]), after))
      } else {
        let items : Array[RedisValue] = []
        let mut pos = after
        let mut i = 0
        while i < count {
          match parse_reply(data, pos) {
            None => return None
            Some((value, next)) => {
              items.push(value)
              pos = next
            }
          }
          i = i + 1
        }
        Some((Array(items), pos))
      }
  }
}

///|
/// Parse the single reply that starts at `pos`; `None` means the buffer does not
/// hold all of it yet.
fn parse_reply(data : Bytes, pos : Int) -> (RedisValue, Int)? {
  if pos >= data.length() {
    return None
  }
  let tag = data[pos]
  if !(tag == b'+' || tag == b'-' || tag == b':' || tag == b'$' || tag == b'*') {
    return Some((Error("Unknown response type"), pos))
  }
  match line_at(data, pos + 1) {
    None => None
    Some((line, after)) =>
      if tag == b'+' {
        Some((SimpleString(line), after))
      } else if tag == b'-' {
        Some((Error(line), after))
      } else if tag == b':' {
        match parse_int_opt(line) {
          Some(number) => Some((Integer(number), after))
          None => Some((Error("Invalid integer: " + line), after))
        }
      } else if tag == b'$' {
        parse_bulk_at(data, line, after)
      } else {
        parse_array_at(data, line, after)
      }
  }
}

///|
/// Parse a complete RESP2 reply held in `response`.
///
/// Frame lengths are byte counts, so the text is re-encoded to UTF-8 before being
/// walked. An input that stops mid-frame yields `Error("Incomplete RESP reply")`
/// rather than a silently shortened value.
pub fn parse_redis_response(response : String) -> RedisValue {
  if response.length() == 0 {
    return Error("Empty response")
  }
  let data = @encoding/utf8.encode(response)
  match parse_reply(data, 0) {
    None => Error("Incomplete RESP reply")
    Some((value, _)) => value
  }
}
