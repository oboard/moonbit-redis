///|
pub struct RedisClient {
  conn : @socket.Tcp
}

///|
/// 连接建立过程中的错误
pub(all) suberror ConnectError {
  /// AUTH 认证失败
  AuthFailed(String)
  /// SELECT 选择数据库失败
  SelectFailed(String)
}

///|
/// 建立到 Redis 服务器的连接。
///
/// 连接建立后可选地自动完成认证和选库：
/// - `password?`：提供时自动发送 AUTH；
///   同时提供 `username?` 时使用 Redis 6+ ACL 形式 `AUTH <username> <password>`。
///   单独提供 `username?` 而不提供 `password?` 时不发送 AUTH（Redis 没有仅用户名的认证）。
/// - `db?`：提供时自动发送 `SELECT <db>` 切换到指定数据库。
///
/// 认证或选库失败时会关闭连接并抛出 `ConnectError`。
pub async fn connect(
  host : StringView,
  port? : Int = 6379,
  protocol? : @socket.IpProtocolPreference,
  username? : String,
  password? : String,
  db? : Int,
) -> RedisClient {
  let conn = @socket.Tcp::connect_to_host(host, port~, protocol?)
  conn.enable_keepalive()
  let client : RedisClient = { conn, }
  if password is Some(password) {
    let args = match username {
      Some(username) => ["AUTH", username, password]
      None => ["AUTH", password]
    }
    match client.send(args) {
      SimpleString("OK") => ()
      Error(e) => {
        client.close()
        raise AuthFailed(e)
      }
      resp => {
        client.close()
        raise AuthFailed("unexpected response: \{resp}")
      }
    }
  }
  if db is Some(db) {
    match client.send(["SELECT", db.to_string()]) {
      SimpleString("OK") => ()
      Error(e) => {
        client.close()
        raise SelectFailed(e)
      }
      resp => {
        client.close()
        raise SelectFailed("unexpected response: \{resp}")
      }
    }
  }
  client
}

///|
pub async fn RedisClient::send(
  self : RedisClient,
  args : Array[String],
) -> RedisValue {
  // println(args)
  let buf = StringBuilder()
  buf.write_string("*" + args.length().to_string() + "\r\n")
  for arg in args {
    // `$<len>` counts bytes, not characters: `length()` truncates every multi-byte
    // payload and leaves the remaining bytes in the socket as a stray command
    let byte_len = @encoding/utf8.encode(arg).length()
    buf.write_string("$\{byte_len.to_string()}\r\n\{arg}\r\n")
  }
  self.conn.write(buf.to_string())
  self.read_redis_value()
}

///|
/// Read exactly one RESP2 reply: take the header line from the stream, then read a
/// bulk body by its declared byte length instead of "whatever one socket read
/// happens to return".
async fn RedisClient::read_value(self : RedisClient) -> RedisValue {
  match self.conn.read_until("\r\n") {
    None => Error("Connection closed")
    Some(line) =>
      if line.length() == 0 {
        Error("Empty response")
      } else {
        let tag = line[0]
        let body = line[1:line.length()].to_owned()
        match tag {
          '+' => SimpleString(body)
          '-' => Error(body)
          ':' =>
            match parse_int_opt(body) {
              Some(number) => Integer(number)
              None => Error("Invalid integer: " + body)
            }
          '$' => self.read_bulk(body)
          '*' => self.read_array(body)
          _ => Error("Unknown response type")
        }
      }
  }
}

///|
/// Read a bulk body: `$-1` is an absent value, otherwise exactly `len` bytes plus
/// the trailing CRLF.
async fn RedisClient::read_bulk(
  self : RedisClient,
  len_text : String,
) -> RedisValue {
  match parse_int_opt(len_text) {
    None => Error("Invalid bulk length: " + len_text)
    Some(len) =>
      if len < 0 {
        BulkString(None)
      } else {
        let payload = Some(self.conn.read_exactly(len + 2)) catch { _ => None }
        match payload {
          None => Error("Connection closed while reading bulk reply")
          Some(data) => BulkString(Some(decode_span(data, 0, len)))
        }
      }
  }
}

///|
/// Read `count` nested replies, each framed on its own.
async fn RedisClient::read_array(
  self : RedisClient,
  count_text : String,
) -> RedisValue {
  match parse_int_opt(count_text) {
    None => Error("Invalid array count: " + count_text)
    Some(count) =>
      if count < 0 {
        Array([])
      } else {
        let items : Array[RedisValue] = []
        for _ in 0..<count {
          items.push(self.read_value())
        }
        Array(items)
      }
  }
}

///|
/// Return the payload of the next reply as text. Kept for source compatibility;
/// `send` and `read_redis_value` give the framed, typed result.
pub async fn RedisClient::read_response(self : RedisClient) -> String {
  let value = self.read_value()
  match value {
    SimpleString(text) | BulkString(Some(text)) => text
    BulkString(None) => ""
    Integer(number) => number.to_string()
    Error(message) => "ERR " + message
    Array(items) => items.map(item => item.to_array_item_string()).join(" ")
  }
}

///|
/// 读取Redis响应并解析为RedisValue类型
pub async fn RedisClient::read_redis_value(self : RedisClient) -> RedisValue {
  self.read_value()
}

///|
pub async fn RedisClient::write(self : RedisClient, data : String) -> Unit {
  self.conn.write(data)
}

///|
pub async fn RedisClient::read(
  self : RedisClient,
  buf : FixedArray[Byte],
) -> Int {
  self.conn.read(buf)
}

///|
pub fn RedisClient::close(self : RedisClient) -> Unit {
  self.conn.close()
}
