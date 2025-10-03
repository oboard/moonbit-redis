// ============ 集合命令 ============

///|
pub async fn RedisClient::sadd(
  self : RedisClient,
  key : String,
  members : Array[String],
) -> RedisInt {
  let args = ["SADD", key, ..members]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::srem(
  self : RedisClient,
  key : String,
  members : Array[String],
) -> RedisInt {
  let args = ["SREM", key, ..members]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::smembers(
  self : RedisClient,
  key : String,
) -> RedisArray {
  self.send(["SMEMBERS", key]).to_array()
}

///|
pub async fn RedisClient::scard(self : RedisClient, key : String) -> RedisInt {
  self.send(["SCARD", key]).to_int()
}

///|
pub async fn RedisClient::sismember(
  self : RedisClient,
  key : String,
  value : String,
) -> RedisInt {
  self.send(["SISMEMBER", key, value]).to_int()
}

///|
pub async fn RedisClient::smismember(
  self : RedisClient,
  key : String,
  members : Array[String],
) -> RedisArray {
  let args = ["SMISMEMBER", key, ..members]
  self.send(args).to_array()
}

///|
pub async fn RedisClient::spop(self : RedisClient, key : String) -> RedisString {
  self.send(["SPOP", key]).to_string()
}

///|
pub async fn RedisClient::srandmember(
  self : RedisClient,
  key : String,
) -> RedisString {
  self.send(["SRANDMEMBER", key]).to_string()
}

///|
pub async fn RedisClient::smove(
  self : RedisClient,
  source : String,
  destination : String,
  value : String,
) -> RedisInt {
  self.send(["SMOVE", source, destination, value]).to_int()
}

///|
pub async fn RedisClient::sdiff(
  self : RedisClient,
  keys : Array[String],
) -> RedisArray {
  let args = ["SDIFF", ..keys]
  self.send(args).to_array()
}

///|
pub async fn RedisClient::sdiffstore(
  self : RedisClient,
  destination : String,
  keys : Array[String],
) -> RedisInt {
  let args = ["SDIFFSTORE", destination, ..keys]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::sinter(
  self : RedisClient,
  keys : Array[String],
) -> RedisInt {
  let args = ["SINTER", ..keys]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::sintercard(
  self : RedisClient,
  numkeys : String,
  keys : Array[String],
) -> RedisInt {
  let args = ["SINTERCARD", numkeys, ..keys]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::sinterstore(
  self : RedisClient,
  destination : String,
  keys : Array[String],
) -> RedisInt {
  let args = ["SINTERSTORE", destination, ..keys]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::sunion(
  self : RedisClient,
  keys : Array[String],
) -> RedisInt {
  let args = ["SUNION", ..keys]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::sunionstore(
  self : RedisClient,
  destination : String,
  keys : Array[String],
) -> RedisInt {
  let args = ["SUNIONSTORE", destination, ..keys]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::sscan(
  self : RedisClient,
  key : String,
  cursor : Int,
  match_pattern? : String,
  count? : Int,
) -> RedisArray {
  let args = ["SSCAN", key, cursor.to_string()]
  if match_pattern is Some(m) {
    args.push("MATCH \{m}")
  }
  if count is Some(c) {
    args.push("COUNT \{c}")
  }
  self.send(args).to_array()
}
