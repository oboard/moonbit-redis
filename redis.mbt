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
    buf.write_string("$\{arg.length()}\r\n\{arg}\r\n")
  }
  self.conn.write(buf.to_string())
  self.read_redis_value()
}

///|
pub async fn RedisClient::read_response(self : RedisClient) -> String {
  let buf = FixedArray::make(4096, b'0')
  if self.conn.read(buf) is n && n > 0 {
    let response_bytes = buf.unsafe_reinterpret_as_bytes()[0:n]
    @encoding/utf8.decode(response_bytes)
  } else {
    ""
  }
}

///|
/// 读取Redis响应并解析为RedisValue类型
pub async fn RedisClient::read_redis_value(self : RedisClient) -> RedisValue {
  let raw_response = self.read_response()
  // println(raw_response)
  parse_redis_response(raw_response)
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
