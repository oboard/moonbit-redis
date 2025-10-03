// ============ 有序集合命令 ============

///|
pub(all) struct ZAddMember {
  score : String
  value : String
}

///|
pub async fn RedisClient::zadd(
  self : RedisClient,
  key : String,
  zadd_members : Array[ZAddMember],
) -> RedisInt {
  let args = [
      "ZADD",
      key,
      ..zadd_members.map(m => [m.score, m.value]).flatten(),
    ]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::zrem(
  self : RedisClient,
  key : String,
  members : Array[String],
) -> RedisInt {
  let args = ["ZREM", key, ..members]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::zrange(
  self : RedisClient,
  key : String,
  start~ : String,
  stop~ : String,
) -> RedisArray {
  self.send(["ZRANGE", key, start, stop]).to_array()
}

///|
pub async fn RedisClient::zrangebyscore(
  self : RedisClient,
  key : String,
  min~ : String,
  max~ : String,
) -> RedisArray {
  self.send(["ZRANGEBYSCORE", key, min, max]).to_array()
}

///|
pub async fn RedisClient::zrangebylex(
  self : RedisClient,
  key : String,
  min~ : String,
  max~ : String,
) -> RedisArray {
  self.send(["ZRANGEBYLEX", key, min, max]).to_array()
}

///|
pub async fn RedisClient::zrevrange(
  self : RedisClient,
  key : String,
  start~ : String,
  stop~ : String,
) -> RedisArray {
  self.send(["ZREVRANGE", key, start, stop]).to_array()
}

///|
pub async fn RedisClient::zrevrangebyscore(
  self : RedisClient,
  key : String,
  max~ : String,
  min~ : String,
) -> RedisArray {
  self.send(["ZREVRANGEBYSCORE", key, max, min]).to_array()
}

///|
pub async fn RedisClient::zrevrangebylex(
  self : RedisClient,
  key : String,
  max~ : String,
  min~ : String,
) -> RedisArray {
  self.send(["ZREVRANGEBYLEX", key, max, min]).to_array()
}

///|
pub async fn RedisClient::zrangestore(
  self : RedisClient,
  dst : String,
  src : String,
  min~ : String,
  max~ : String,
) -> RedisInt {
  self.send(["ZRANGESTORE", dst, src, min, max]).to_int()
}

///|
pub async fn RedisClient::zscore(
  self : RedisClient,
  key : String,
  value : String,
) -> RedisString {
  self.send(["ZSCORE", key, value]).to_string()
}

///|
pub async fn RedisClient::zmscore(
  self : RedisClient,
  key : String,
  members : Array[String],
) -> RedisArray {
  let args = ["ZMSCORE", key, ..members]
  self.send(args).to_array()
}

///|
pub async fn RedisClient::zcard(self : RedisClient, key : String) -> RedisInt {
  self.send(["ZCARD", key]).to_int()
}

///|
pub async fn RedisClient::zcount(
  self : RedisClient,
  key : String,
  min~ : String,
  max~ : String,
) -> RedisInt {
  self.send(["ZCOUNT", key, min, max]).to_int()
}

///|
pub async fn RedisClient::zlexcount(
  self : RedisClient,
  key : String,
  min~ : String,
  max~ : String,
) -> RedisInt {
  self.send(["ZLEXCOUNT", key, min, max]).to_int()
}

///|
pub async fn RedisClient::zrank(
  self : RedisClient,
  key : String,
  value : String,
) -> RedisInt {
  self.send(["ZRANK", key, value]).to_int()
}

///|
pub async fn RedisClient::zrevrank(
  self : RedisClient,
  key : String,
  value : String,
) -> RedisInt {
  self.send(["ZREVRANK", key, value]).to_int()
}

///|
pub async fn RedisClient::zincrby(
  self : RedisClient,
  key : String,
  increment~ : String,
  value~ : String,
) -> RedisString {
  self.send(["ZINCRBY", key, increment, value]).to_string()
}

///|
pub async fn RedisClient::zpopmax(
  self : RedisClient,
  key : String,
) -> RedisString {
  self.send(["ZPOPMAX", key]).to_string()
}

///|
pub async fn RedisClient::zpopmin(
  self : RedisClient,
  key : String,
) -> RedisString {
  self.send(["ZPOPMIN", key]).to_string()
}

///|
pub async fn RedisClient::bzpopmax(
  self : RedisClient,
  keys : Array[String],
  timeout : String,
) -> RedisString {
  let args = ["BZPOPMAX", ..keys, timeout]
  self.send(args).to_string()
}

///|
pub async fn RedisClient::bzpopmin(
  self : RedisClient,
  keys : Array[String],
  timeout : String,
) -> RedisString {
  let args = ["BZPOPMIN", ..keys, timeout]
  self.send(args).to_string()
}

///|
pub async fn RedisClient::zrandmember(
  self : RedisClient,
  key : String,
) -> RedisString {
  self.send(["ZRANDMEMBER", key]).to_string()
}

///|
pub async fn RedisClient::zremrangebyrank(
  self : RedisClient,
  key : String,
  start : String,
  stop : String,
) -> RedisInt {
  self.send(["ZREMRANGEBYRANK", key, start, stop]).to_int()
}

///|
pub async fn RedisClient::zremrangebyscore(
  self : RedisClient,
  key : String,
  min : String,
  max : String,
) -> RedisInt {
  self.send(["ZREMRANGEBYSCORE", key, min, max]).to_int()
}

///|
pub async fn RedisClient::zremrangebylex(
  self : RedisClient,
  key : String,
  min : String,
  max : String,
) -> RedisInt {
  self.send(["ZREMRANGEBYLEX", key, min, max]).to_int()
}

///|
pub async fn RedisClient::zunion(
  self : RedisClient,
  numkeys : String,
  keys : Array[String],
) -> RedisArray {
  let args = ["ZUNION", numkeys, ..keys]
  self.send(args).to_array()
}

///|
pub async fn RedisClient::zunionstore(
  self : RedisClient,
  destination : String,
  numkeys : String,
  keys : Array[String],
) -> RedisInt {
  let args = ["ZUNIONSTORE", destination, numkeys, ..keys]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::zinter(
  self : RedisClient,
  numkeys : String,
  keys : Array[String],
) -> RedisArray {
  let args = ["ZINTER", numkeys, ..keys]
  self.send(args).to_array()
}

///|
pub async fn RedisClient::zintercard(
  self : RedisClient,
  numkeys : String,
  keys : Array[String],
) -> RedisInt {
  let args = ["ZINTERCARD", numkeys, ..keys]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::zinterstore(
  self : RedisClient,
  destination : String,
  numkeys : String,
  keys : Array[String],
) -> RedisInt {
  let args = ["ZINTERSTORE", destination, numkeys, ..keys]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::zdiff(
  self : RedisClient,
  numkeys : String,
  keys : Array[String],
) -> RedisArray {
  let args = ["ZDIFF", numkeys, ..keys]
  self.send(args).to_array()
}

///|
pub async fn RedisClient::zdiffstore(
  self : RedisClient,
  destination : String,
  numkeys : String,
  keys : Array[String],
) -> RedisInt {
  let args = ["ZDIFFSTORE", destination, numkeys, ..keys]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::zmpop(
  self : RedisClient,
  numkeys : String,
  keys : Array[String],
  value : String,
) -> RedisArray {
  let args = ["ZMPOP", numkeys, ..keys, value]
  self.send(args).to_array()
}

///|
pub async fn RedisClient::bzmpop(
  self : RedisClient,
  timeout : String,
  numkeys : String,
  keys : Array[String],
  where_ : String,
  count : String?, // optional COUNT argument
) -> RedisArray {
  let args = match count {
    Some(c) => ["BZMPOP", timeout, numkeys, ..keys, where_, "COUNT", c]
    None => ["BZMPOP", timeout, numkeys, ..keys, where_]
  }
  self.send(args).to_array()
}

///|
pub async fn RedisClient::zscan(
  self : RedisClient,
  key : String,
  cursor : String,
) -> RedisArray {
  self.send(["ZSCAN", key, cursor]).to_array()
}
