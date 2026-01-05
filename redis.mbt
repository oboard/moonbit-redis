///|
pub struct RedisClient {
  conn : @socket.Tcp
}

///|
pub async fn connect(host : String, port : Int) -> RedisClient {
  let conn = @socket.Tcp::connect_to_host(host, port~)
  conn.enable_keepalive()
  { conn, }
}

///|
pub async fn RedisClient::send(
  self : RedisClient,
  args : Array[String],
) -> RedisValue {
  // println(args)
  let buf = @buffer.new()
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
