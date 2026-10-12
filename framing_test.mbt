///|
/// RESP framing tests: bulk replies must be read to the declared byte length, and
/// request frames must be sized in bytes (not characters), so non-ASCII payloads
/// and values longer than one socket read survive a round trip.

///|
fn framing_test_key(name : String) -> String {
  "test:framing:\{name}"
}

///|
fn utf8_len(s : String) -> Int {
  @encoding/utf8.encode(s).length()
}

///|
fn repeat(unit : String, n : Int) -> String {
  let parts : Array[String] = []
  for _ in 0..<n {
    parts.push(unit)
  }
  parts.join("")
}

///|
/// Unwrap helpers: comparing against a computed value must not use `is Ok(x)`,
/// because a lowercase identifier there binds a pattern variable and matches
/// anything.
fn text_of(r : Result[String, String]) -> String {
  match r {
    Ok(v) => v
    Err(_) => ""
  }
}

///|
fn int_of(r : Result[Int, String]) -> Int {
  match r {
    Ok(v) => v
    Err(_) => -1
  }
}

///|
/// A bulk reply bigger than a single socket read must arrive whole, and the
/// connection must still be usable afterwards.
async test "framing_bulk_over_read_chunk" {
  let client = @redis.connect("localhost", port=6379)
  defer client.close()
  let key = framing_test_key("big")
  let _ = client.del([key])

  let payload = repeat("abcdefghijklmnopqrstuvwxyz0123456789AB", 200) // 8000 bytes
  assert_true(client.set(key, payload) is Ok("OK"))
  assert_true(text_of(client.get(key)) == payload)
  assert_true(int_of(client.strlen(key)) == utf8_len(payload))
  // the reply above spans several reads: the stream must stay framed
  assert_true(client.ping() is Ok("PONG"))
  let _ = client.del([key])
}

///|
/// `$len` is a byte count: a non-ASCII value must round trip unchanged.
async test "framing_utf8_value" {
  let client = @redis.connect("localhost", port=6379)
  defer client.close()
  let key = framing_test_key("utf8")
  let _ = client.del([key])

  let payload = "张三丰-研发部-高级工程师-🚀"
  assert_true(client.set(key, payload) is Ok("OK"))
  assert_true(text_of(client.get(key)) == payload)
  // most characters above are multi-byte, so STRLEN (bytes) exceeds length (chars)
  assert_true(int_of(client.strlen(key)) == utf8_len(payload))
  assert_true(utf8_len(payload) > payload.length())
  let _ = client.del([key])
}

///|
/// Bulk content may contain CRLF; the parser must trust the length, not the first
/// line break.
async test "framing_bulk_with_crlf" {
  let client = @redis.connect("localhost", port=6379)
  defer client.close()
  let key = framing_test_key("crlf")
  let _ = client.del([key])

  let payload = "line1\r\nline2\r\nline3"
  assert_true(client.set(key, payload) is Ok("OK"))
  assert_true(text_of(client.get(key)) == payload)
  assert_true(int_of(client.strlen(key)) == 19)
  let _ = client.del([key])
}

///|
/// Multi-line bulk replies (INFO) must not stop at the first line.
async test "framing_multiline_bulk" {
  let client = @redis.connect("localhost", port=6379)
  defer client.close()
  let has_fields = match client.info() {
    BulkString(Some(text)) =>
      text.contains("redis_version:") && text.contains("connected_clients")
    _ => false
  }
  assert_true(has_fields)
}

///|
/// Wide array replies (many hash fields) span several reads as well.
async test "framing_wide_hash" {
  let client = @redis.connect("localhost", port=6379)
  defer client.close()
  let key = framing_test_key("wide_hash")
  let _ = client.del([key])

  for i in 0..<300 {
    let _ = client.hset(key, "f\{i.to_string()}", "v\{i.to_string()}")
  }
  let field_count = match client.hgetall(key) {
    Ok(map) => map.length()
    Err(_) => -1
  }
  assert_true(field_count == 300)
  assert_true(int_of(client.hlen(key)) == 300)
  assert_true(text_of(client.hget(key, "f299")) == "v299")
  let _ = client.del([key])
}
