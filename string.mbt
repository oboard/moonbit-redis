// ============ 字符串命令 ============

///|
pub async fn RedisClient::ping(self : RedisClient) -> RedisString {
  self.send(["PING"]).to_string()
}

///|
pub async fn RedisClient::set(
  self : RedisClient,
  key : String,
  value : String,
) -> RedisString {
  self.send(["SET", key, value]).to_string()
}

///|
pub async fn RedisClient::get(self : RedisClient, key : String) -> RedisString {
  self.send(["GET", key]).to_string()
}

///|
pub async fn RedisClient::append(
  self : RedisClient,
  key : String,
  value : String,
) -> RedisInt {
  self.send(["APPEND", key, value]).to_int()
}

///|
pub async fn RedisClient::strlen(self : RedisClient, key : String) -> RedisInt {
  self.send(["STRLEN", key]).to_int()
}

///|
pub async fn RedisClient::incr(self : RedisClient, key : String) -> RedisInt {
  self.send(["INCR", key]).to_int()
}

///|
pub async fn RedisClient::decr(self : RedisClient, key : String) -> RedisInt {
  self.send(["DECR", key]).to_int()
}

///|
pub async fn RedisClient::incrby(
  self : RedisClient,
  key : String,
  increment : String,
) -> RedisInt {
  self.send(["INCRBY", key, increment]).to_int()
}

///|
pub async fn RedisClient::decrby(
  self : RedisClient,
  key : String,
  decrement : String,
) -> RedisInt {
  self.send(["DECRBY", key, decrement]).to_int()
}

///|
pub async fn RedisClient::incrbyfloat(
  self : RedisClient,
  key : String,
  increment : String,
) -> RedisString {
  self.send(["INCRBYFLOAT", key, increment]).to_string()
}

///|
pub async fn RedisClient::getrange(
  self : RedisClient,
  key : String,
  start : String,
  end : String,
) -> RedisString {
  self.send(["GETRANGE", key, start, end]).to_string()
}

///|
pub async fn RedisClient::setrange(
  self : RedisClient,
  key : String,
  offset : String,
  value : String,
) -> RedisInt {
  self.send(["SETRANGE", key, offset, value]).to_int()
}

///|
pub async fn RedisClient::getset(
  self : RedisClient,
  key : String,
  value : String,
) -> RedisString {
  self.send(["GETSET", key, value]).to_string()
}

///|
pub async fn RedisClient::getdel(
  self : RedisClient,
  key : String,
) -> RedisString {
  self.send(["GETDEL", key]).to_string()
}

///|
pub async fn RedisClient::getex(
  self : RedisClient,
  key : String,
  ex : String,
) -> RedisString {
  self.send(["GETEX", key, "EX", ex]).to_string()
}

///|
pub async fn RedisClient::setex(
  self : RedisClient,
  key : String,
  seconds : String,
  value : String,
) -> RedisString {
  self.send(["SETEX", key, seconds, value]).to_string()
}

///|
pub async fn RedisClient::psetex(
  self : RedisClient,
  key : String,
  milliseconds : String,
  value : String,
) -> RedisString {
  self.send(["PSETEX", key, milliseconds, value]).to_string()
}

///|
pub async fn RedisClient::setnx(
  self : RedisClient,
  key : String,
  value : String,
) -> RedisInt {
  self.send(["SETNX", key, value]).to_int()
}

///|
pub async fn RedisClient::mset(
  self : RedisClient,
  key_values : Map[String, String],
) -> RedisString {
  let arr = key_values
    .map(fn(k, v) -> Array[String] { [k, v] })
    .values()
    .to_array()
    .flatten()
  let args = ["MSET", ..arr]
  self.send(args).to_string()
}

///|
pub async fn RedisClient::mget(
  self : RedisClient,
  keys : Array[String],
) -> RedisArray {
  let args = ["MGET", ..keys]
  self.send(args).to_array()
}

///|
pub async fn RedisClient::msetnx(
  self : RedisClient,
  key_values : Map[String, String],
) -> RedisInt {
  let arr = key_values
    .map(fn(k, v) -> Array[String] { [k, v] })
    .values()
    .to_array()
    .flatten()
  let args = ["MSETNX", ..arr]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::substr(
  self : RedisClient,
  key : String,
  start : Int,
  end : Int,
) -> RedisString {
  self.send(["SUBSTR", key, start.to_string(), end.to_string()]).to_string()
}
