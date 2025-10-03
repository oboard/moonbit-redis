// ============ 集合命令 ============

///|
pub async fn RedisClient::sadd(
  self : RedisClient,
  key : String,
  members : Array[String],
) -> String {
  let args = ["SADD", key, ..members]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::srem(
  self : RedisClient,
  key : String,
  members : Array[String],
) -> String {
  let args = ["SREM", key, ..members]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::smembers(self : RedisClient, key : String) -> String {
  self.send(["SMEMBERS", key])
  self.read_response()
}

///|
pub async fn RedisClient::scard(self : RedisClient, key : String) -> String {
  self.send(["SCARD", key])
  self.read_response()
}

///|
pub async fn RedisClient::sismember(
  self : RedisClient,
  key : String,
  value : String,
) -> String {
  self.send(["SISMEMBER", key, value])
  self.read_response()
}

///|
pub async fn RedisClient::smismember(
  self : RedisClient,
  key : String,
  members : Array[String],
) -> String {
  let args = ["SMISMEMBER", key, ..members]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::spop(self : RedisClient, key : String) -> String {
  self.send(["SPOP", key])
  self.read_response()
}

///|
pub async fn RedisClient::srandmember(
  self : RedisClient,
  key : String,
) -> String {
  self.send(["SRANDMEMBER", key])
  self.read_response()
}

///|
pub async fn RedisClient::smove(
  self : RedisClient,
  source : String,
  destination : String,
  value : String,
) -> String {
  self.send(["SMOVE", source, destination, value])
  self.read_response()
}

///|
pub async fn RedisClient::sdiff(
  self : RedisClient,
  keys : Array[String],
) -> String {
  let args = ["SDIFF", ..keys]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::sdiffstore(
  self : RedisClient,
  destination : String,
  keys : Array[String],
) -> String {
  let args = ["SDIFFSTORE", destination, ..keys]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::sinter(
  self : RedisClient,
  keys : Array[String],
) -> String {
  let args = ["SINTER", ..keys]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::sintercard(
  self : RedisClient,
  numkeys : String,
  keys : Array[String],
) -> String {
  let args = ["SINTERCARD", numkeys, ..keys]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::sinterstore(
  self : RedisClient,
  destination : String,
  keys : Array[String],
) -> String {
  let args = ["SINTERSTORE", destination, ..keys]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::sunion(
  self : RedisClient,
  keys : Array[String],
) -> String {
  let args = ["SUNION", ..keys]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::sunionstore(
  self : RedisClient,
  destination : String,
  keys : Array[String],
) -> String {
  let args = ["SUNIONSTORE", destination, ..keys]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::sscan(
  self : RedisClient,
  key : String,
  cursor : String,
) -> String {
  self.send(["SSCAN", key, cursor])
  self.read_response()
}
