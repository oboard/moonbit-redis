// ============ 列表命令 ============

///|
pub async fn RedisClient::lpush(
  self : RedisClient,
  key : String,
  values : Array[String],
) -> RedisInt {
  let args = ["LPUSH", key, ..values]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::rpush(
  self : RedisClient,
  key : String,
  values : Array[String],
) -> RedisInt {
  let args = ["RPUSH", key, ..values]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::lpop(self : RedisClient, key : String) -> RedisString {
  self.send(["LPOP", key]).to_string()
}

///|
pub async fn RedisClient::rpop(self : RedisClient, key : String) -> RedisString {
  self.send(["RPOP", key]).to_string()
}

///|
pub async fn RedisClient::lpushx(
  self : RedisClient,
  key : String,
  values : Array[String],
) -> RedisInt {
  let args = ["LPUSHX", key, ..values]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::rpushx(
  self : RedisClient,
  key : String,
  values : Array[String],
) -> RedisInt {
  let args = ["RPUSHX", key, ..values]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::llen(self : RedisClient, key : String) -> RedisInt {
  self.send(["LLEN", key]).to_int()
}

///|
pub async fn RedisClient::lrange(
  self : RedisClient,
  key : String,
  start~ : Int,
  stop~ : Int,
) -> RedisArray {
  self.send(["LRANGE", key, start.to_string(), stop.to_string()]).to_array()
}

///|
pub async fn RedisClient::lindex(
  self : RedisClient,
  key : String,
  index~ : Int,
) -> RedisString {
  self.send(["LINDEX", key, index.to_string()]).to_string()
}

///|
pub async fn RedisClient::lset(
  self : RedisClient,
  key : String,
  index~ : Int,
  value~ : String,
) -> RedisString {
  self.send(["LSET", key, index.to_string(), value]).to_string()
}

///|
pub async fn RedisClient::lrem(
  self : RedisClient,
  key : String,
  count~ : Int,
  value~ : String,
) -> RedisInt {
  self.send(["LREM", key, count.to_string(), value]).to_int()
}

///|
pub async fn RedisClient::ltrim(
  self : RedisClient,
  key : String,
  start~ : Int,
  stop~ : Int,
) -> RedisString {
  self.send(["LTRIM", key, start.to_string(), stop.to_string()]).to_string()
}

///|
pub async fn RedisClient::linsert(
  self : RedisClient,
  key : String,
  where_~ : String,
  pivot~ : String,
  element~ : String,
) -> RedisInt {
  self.send(["LINSERT", key, where_, pivot, element]).to_int()
}

///|
pub async fn RedisClient::rpoplpush(
  self : RedisClient,
  source : String,
  destination : String,
) -> RedisValue {
  self.send(["RPOPLPUSH", source, destination])
}

///|
pub async fn RedisClient::lmove(
  self : RedisClient,
  source : String,
  destination : String,
  wherefrom~ : Int,
  whereto~ : Int,
) -> RedisValue {
  self.send([
    "LMOVE",
    source,
    destination,
    wherefrom.to_string(),
    whereto.to_string(),
  ])
}

///|
pub async fn RedisClient::lpos(
  self : RedisClient,
  key : String,
  element~ : String,
) -> RedisValue {
  self.send(["LPOS", key, element])
}

///|
pub async fn RedisClient::blpop(
  self : RedisClient,
  keys : Array[String],
  timeout~ : Int,
) -> RedisValue {
  let args = ["BLPOP", ..keys, timeout.to_string()]
  self.send(args)
}

///|
pub async fn RedisClient::brpop(
  self : RedisClient,
  keys : Array[String],
  timeout~ : Int,
) -> RedisValue {
  let args = ["BRPOP", ..keys, timeout.to_string()]
  self.send(args)
}

///|
pub async fn RedisClient::brpoplpush(
  self : RedisClient,
  source : String,
  destination : String,
  timeout~ : Int,
) -> RedisValue {
  self.send(["BRPOPLPUSH", source, destination, timeout.to_string()])
}

///|
pub async fn RedisClient::blmove(
  self : RedisClient,
  source : String,
  destination : String,
  wherefrom~ : Int,
  whereto~ : Int,
  timeout~ : Int,
) -> RedisValue {
  self.send([
    "BLMOVE",
    source,
    destination,
    wherefrom.to_string(),
    whereto.to_string(),
    timeout.to_string(),
  ])
}

///|
pub async fn RedisClient::lmpop(
  self : RedisClient,
  numkeys : String,
  keys : Array[String],
  where_~ : String,
) -> RedisValue {
  let args = ["LMPOP", numkeys, ..keys, where_]
  self.send(args)
}

///|
pub async fn RedisClient::blmpop(
  self : RedisClient,
  timeout~ : Int,
  numkeys : String,
  keys : Array[String],
  where_~ : String,
) -> RedisValue {
  let args = ["BLMPOP", timeout.to_string(), numkeys, ..keys, where_]
  self.send(args)
}
