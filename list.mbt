// ============ 列表命令 ============

///|
pub async fn RedisClient::lpush(
  self : RedisClient,
  key : String,
  values : Array[String],
) -> String {
  let args = ["LPUSH", key, ..values]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::rpush(
  self : RedisClient,
  key : String,
  values : Array[String],
) -> String {
  let args = ["RPUSH", key, ..values]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::lpop(self : RedisClient, key : String) -> String {
  self.send(["LPOP", key])
  self.read_response()
}

///|
pub async fn RedisClient::rpop(self : RedisClient, key : String) -> String {
  self.send(["RPOP", key])
  self.read_response()
}

///|
pub async fn RedisClient::lpushx(
  self : RedisClient,
  key : String,
  values : Array[String],
) -> String {
  let args = ["LPUSHX", key, ..values]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::rpushx(
  self : RedisClient,
  key : String,
  values : Array[String],
) -> String {
  let args = ["RPUSHX", key, ..values]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::llen(self : RedisClient, key : String) -> String {
  self.send(["LLEN", key])
  self.read_response()
}

///|
pub async fn RedisClient::lrange(
  self : RedisClient,
  key : String,
  start : String,
  stop : String,
) -> String {
  self.send(["LRANGE", key, start, stop])
  self.read_response()
}

///|
pub async fn RedisClient::lindex(
  self : RedisClient,
  key : String,
  index : String,
) -> String {
  self.send(["LINDEX", key, index])
  self.read_response()
}

///|
pub async fn RedisClient::lset(
  self : RedisClient,
  key : String,
  index : String,
  value : String,
) -> String {
  self.send(["LSET", key, index, value])
  self.read_response()
}

///|
pub async fn RedisClient::lrem(
  self : RedisClient,
  key : String,
  count : String,
  value : String,
) -> String {
  self.send(["LREM", key, count, value])
  self.read_response()
}

///|
pub async fn RedisClient::ltrim(
  self : RedisClient,
  key : String,
  start : String,
  stop : String,
) -> String {
  self.send(["LTRIM", key, start, stop])
  self.read_response()
}

///|
pub async fn RedisClient::linsert(
  self : RedisClient,
  key : String,
  where_ : String,
  pivot : String,
  element : String,
) -> String {
  self.send(["LINSERT", key, where_, pivot, element])
  self.read_response()
}

///|
pub async fn RedisClient::rpoplpush(
  self : RedisClient,
  source : String,
  destination : String,
) -> String {
  self.send(["RPOPLPUSH", source, destination])
  self.read_response()
}

///|
pub async fn RedisClient::lmove(
  self : RedisClient,
  source : String,
  destination : String,
  wherefrom : String,
  whereto : String,
) -> String {
  self.send(["LMOVE", source, destination, wherefrom, whereto])
  self.read_response()
}

///|
pub async fn RedisClient::lpos(
  self : RedisClient,
  key : String,
  element : String,
) -> String {
  self.send(["LPOS", key, element])
  self.read_response()
}

///|
pub async fn RedisClient::blpop(
  self : RedisClient,
  keys : Array[String],
  timeout : String,
) -> String {
  let args = ["BLPOP", ..keys, timeout]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::brpop(
  self : RedisClient,
  keys : Array[String],
  timeout : String,
) -> String {
  let args = ["BRPOP", ..keys, timeout]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::brpoplpush(
  self : RedisClient,
  source : String,
  destination : String,
  timeout : String,
) -> String {
  self.send(["BRPOPLPUSH", source, destination, timeout])
  self.read_response()
}

///|
pub async fn RedisClient::blmove(
  self : RedisClient,
  source : String,
  destination : String,
  wherefrom : String,
  whereto : String,
  timeout : String,
) -> String {
  self.send(["BLMOVE", source, destination, wherefrom, whereto, timeout])
  self.read_response()
}

///|
pub async fn RedisClient::lmpop(
  self : RedisClient,
  numkeys : String,
  keys : Array[String],
  where_ : String,
) -> String {
  let args = ["LMPOP", numkeys, ..keys, where_]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::blmpop(
  self : RedisClient,
  timeout : String,
  numkeys : String,
  keys : Array[String],
  where_ : String,
) -> String {
  let args = ["BLMPOP", timeout, numkeys, ..keys, where_]
  self.send(args)
  self.read_response()
}
