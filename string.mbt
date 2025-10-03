// ============ 字符串命令 ============

///|
pub async fn RedisClient::ping(self : RedisClient) -> String {
  self.send(["PING"])
  self.read_response()
}

///|
pub async fn RedisClient::set(
  self : RedisClient,
  key : String,
  value : String,
) -> String {
  self.send(["SET", key, value])
  self.read_response()
}

///|
pub async fn RedisClient::get(self : RedisClient, key : String) -> String {
  self.send(["GET", key])
  self.read_response()
}

///|
pub async fn RedisClient::append(
  self : RedisClient,
  key : String,
  value : String,
) -> String {
  self.send(["APPEND", key, value])
  self.read_response()
}

///|
pub async fn RedisClient::strlen(self : RedisClient, key : String) -> String {
  self.send(["STRLEN", key])
  self.read_response()
}

///|
pub async fn RedisClient::incr(self : RedisClient, key : String) -> String {
  self.send(["INCR", key])
  self.read_response()
}

///|
pub async fn RedisClient::decr(self : RedisClient, key : String) -> String {
  self.send(["DECR", key])
  self.read_response()
}

///|
pub async fn RedisClient::incrby(
  self : RedisClient,
  key : String,
  increment : String,
) -> String {
  self.send(["INCRBY", key, increment])
  self.read_response()
}

///|
pub async fn RedisClient::decrby(
  self : RedisClient,
  key : String,
  decrement : String,
) -> String {
  self.send(["DECRBY", key, decrement])
  self.read_response()
}

///|
pub async fn RedisClient::incrbyfloat(
  self : RedisClient,
  key : String,
  increment : String,
) -> String {
  self.send(["INCRBYFLOAT", key, increment])
  self.read_response()
}

///|
pub async fn RedisClient::getrange(
  self : RedisClient,
  key : String,
  start : String,
  end : String,
) -> String {
  self.send(["GETRANGE", key, start, end])
  self.read_response()
}

///|
pub async fn RedisClient::setrange(
  self : RedisClient,
  key : String,
  offset : String,
  value : String,
) -> String {
  self.send(["SETRANGE", key, offset, value])
  self.read_response()
}

///|
pub async fn RedisClient::getset(
  self : RedisClient,
  key : String,
  value : String,
) -> String {
  self.send(["GETSET", key, value])
  self.read_response()
}

///|
pub async fn RedisClient::getdel(self : RedisClient, key : String) -> String {
  self.send(["GETDEL", key])
  self.read_response()
}

///|
pub async fn RedisClient::getex(
  self : RedisClient,
  key : String,
  ex : String,
) -> String {
  self.send(["GETEX", key, "EX", ex])
  self.read_response()
}

///|
pub async fn RedisClient::setex(
  self : RedisClient,
  key : String,
  seconds : String,
  value : String,
) -> String {
  self.send(["SETEX", key, seconds, value])
  self.read_response()
}

///|
pub async fn RedisClient::psetex(
  self : RedisClient,
  key : String,
  milliseconds : String,
  value : String,
) -> String {
  self.send(["PSETEX", key, milliseconds, value])
  self.read_response()
}

///|
pub async fn RedisClient::setnx(
  self : RedisClient,
  key : String,
  value : String,
) -> String {
  self.send(["SETNX", key, value])
  self.read_response()
}

///|
pub async fn RedisClient::mset(
  self : RedisClient,
  key_values : Array[String],
) -> String {
  let args = ["MSET", ..key_values]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::mget(
  self : RedisClient,
  keys : Array[String],
) -> String {
  let args = ["MGET", ..keys]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::msetnx(
  self : RedisClient,
  key_values : Array[String],
) -> String {
  let args = ["MSETNX", ..key_values]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::substr(
  self : RedisClient,
  key : String,
  start : String,
  end : String,
) -> String {
  self.send(["SUBSTR", key, start, end])
  self.read_response()
}
