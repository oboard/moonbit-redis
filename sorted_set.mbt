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
) -> RedisValue {
  let args = [
      "ZADD",
      key,
      ..zadd_members.map(m => [m.score, m.value]).flatten(),
    ]
  self.send(args)
}

///|
pub async fn RedisClient::zrem(
  self : RedisClient,
  key : String,
  members : Array[String],
) -> RedisValue {
  let args = ["ZREM", key, ..members]
  self.send(args)
}

///|
pub async fn RedisClient::zrange(
  self : RedisClient,
  key : String,
  start : String,
  stop : String,
) -> RedisValue {
  self.send(["ZRANGE", key, start, stop])
}

///|
pub async fn RedisClient::zrangebyscore(
  self : RedisClient,
  key : String,
  min : String,
  max : String,
) -> RedisValue {
  self.send(["ZRANGEBYSCORE", key, min, max])
}

///|
pub async fn RedisClient::zrangebylex(
  self : RedisClient,
  key : String,
  min : String,
  max : String,
) -> RedisValue {
  self.send(["ZRANGEBYLEX", key, min, max])
}

///|
pub async fn RedisClient::zrevrange(
  self : RedisClient,
  key : String,
  start : String,
  stop : String,
) -> RedisValue {
  self.send(["ZREVRANGE", key, start, stop])
}

///|
pub async fn RedisClient::zrevrangebyscore(
  self : RedisClient,
  key : String,
  max : String,
  min : String,
) -> RedisValue {
  self.send(["ZREVRANGEBYSCORE", key, max, min])
}

///|
pub async fn RedisClient::zrevrangebylex(
  self : RedisClient,
  key : String,
  max : String,
  min : String,
) -> RedisValue {
  self.send(["ZREVRANGEBYLEX", key, max, min])
}

///|
pub async fn RedisClient::zrangestore(
  self : RedisClient,
  dst : String,
  src : String,
  min : String,
  max : String,
) -> RedisValue {
  self.send(["ZRANGESTORE", dst, src, min, max])
}

///|
pub async fn RedisClient::zscore(
  self : RedisClient,
  key : String,
  value : String,
) -> RedisValue {
  self.send(["ZSCORE", key, value])
}

///|
pub async fn RedisClient::zmscore(
  self : RedisClient,
  key : String,
  members : Array[String],
) -> RedisValue {
  let args = ["ZMSCORE", key, ..members]
  self.send(args)
}

///|
pub async fn RedisClient::zcard(self : RedisClient, key : String) -> RedisValue {
  self.send(["ZCARD", key])
}

///|
pub async fn RedisClient::zcount(
  self : RedisClient,
  key : String,
  min : String,
  max : String,
) -> RedisValue {
  self.send(["ZCOUNT", key, min, max])
}

///|
pub async fn RedisClient::zlexcount(
  self : RedisClient,
  key : String,
  min : String,
  max : String,
) -> RedisValue {
  self.send(["ZLEXCOUNT", key, min, max])
}

///|
pub async fn RedisClient::zrank(
  self : RedisClient,
  key : String,
  value : String,
) -> RedisValue {
  self.send(["ZRANK", key, value])
}

///|
pub async fn RedisClient::zrevrank(
  self : RedisClient,
  key : String,
  value : String,
) -> RedisValue {
  self.send(["ZREVRANK", key, value])
}

///|
pub async fn RedisClient::zincrby(
  self : RedisClient,
  key : String,
  increment~ : String,
  value~ : String,
) -> RedisValue {
  self.send(["ZINCRBY", key, increment, value])
}

///|
pub async fn RedisClient::zpopmax(
  self : RedisClient,
  key : String,
) -> RedisValue {
  self.send(["ZPOPMAX", key])
}

///|
pub async fn RedisClient::zpopmin(
  self : RedisClient,
  key : String,
) -> RedisValue {
  self.send(["ZPOPMIN", key])
}

///|
pub async fn RedisClient::bzpopmax(
  self : RedisClient,
  keys : Array[String],
  timeout : String,
) -> RedisValue {
  let args = ["BZPOPMAX", ..keys, timeout]
  self.send(args)
}

///|
pub async fn RedisClient::bzpopmin(
  self : RedisClient,
  keys : Array[String],
  timeout : String,
) -> RedisValue {
  let args = ["BZPOPMIN", ..keys, timeout]
  self.send(args)
}

///|
pub async fn RedisClient::zrandmember(
  self : RedisClient,
  key : String,
) -> RedisValue {
  self.send(["ZRANDMEMBER", key])
}

///|
pub async fn RedisClient::zremrangebyrank(
  self : RedisClient,
  key : String,
  start : String,
  stop : String,
) -> RedisValue {
  self.send(["ZREMRANGEBYRANK", key, start, stop])
}

///|
pub async fn RedisClient::zremrangebyscore(
  self : RedisClient,
  key : String,
  min : String,
  max : String,
) -> RedisValue {
  self.send(["ZREMRANGEBYSCORE", key, min, max])
}

///|
pub async fn RedisClient::zremrangebylex(
  self : RedisClient,
  key : String,
  min : String,
  max : String,
) -> RedisValue {
  self.send(["ZREMRANGEBYLEX", key, min, max])
}

///|
pub async fn RedisClient::zunion(
  self : RedisClient,
  numkeys : String,
  keys : Array[String],
) -> RedisValue {
  let args = ["ZUNION", numkeys, ..keys]
  self.send(args)
}

///|
pub async fn RedisClient::zunionstore(
  self : RedisClient,
  destination : String,
  numkeys : String,
  keys : Array[String],
) -> RedisValue {
  let args = ["ZUNIONSTORE", destination, numkeys, ..keys]
  self.send(args)
}

///|
pub async fn RedisClient::zinter(
  self : RedisClient,
  numkeys : String,
  keys : Array[String],
) -> RedisValue {
  let args = ["ZINTER", numkeys, ..keys]
  self.send(args)
}

///|
pub async fn RedisClient::zintercard(
  self : RedisClient,
  numkeys : String,
  keys : Array[String],
) -> RedisValue {
  let args = ["ZINTERCARD", numkeys, ..keys]
  self.send(args)
}

///|
pub async fn RedisClient::zinterstore(
  self : RedisClient,
  destination : String,
  numkeys : String,
  keys : Array[String],
) -> RedisValue {
  let args = ["ZINTERSTORE", destination, numkeys, ..keys]
  self.send(args)
}

///|
pub async fn RedisClient::zdiff(
  self : RedisClient,
  numkeys : String,
  keys : Array[String],
) -> RedisValue {
  let args = ["ZDIFF", numkeys, ..keys]
  self.send(args)
}

///|
pub async fn RedisClient::zdiffstore(
  self : RedisClient,
  destination : String,
  numkeys : String,
  keys : Array[String],
) -> RedisValue {
  let args = ["ZDIFFSTORE", destination, numkeys, ..keys]
  self.send(args)
}

///|
pub async fn RedisClient::zmpop(
  self : RedisClient,
  numkeys : String,
  keys : Array[String],
  value : String,
) -> RedisValue {
  let args = ["ZMPOP", numkeys, ..keys, value]
  self.send(args)
}

///|
pub async fn RedisClient::bzmpop(
  self : RedisClient,
  timeout : String,
  numkeys : String,
  keys : Array[String],
  where_ : String,
  count : String?, // optional COUNT argument
) -> RedisValue {
  let args = match count {
    Some(c) => ["BZMPOP", timeout, numkeys, ..keys, where_, "COUNT", c]
    None => ["BZMPOP", timeout, numkeys, ..keys, where_]
  }
  self.send(args)
}

///|
pub async fn RedisClient::zscan(
  self : RedisClient,
  key : String,
  cursor : String,
) -> RedisValue {
  self.send(["ZSCAN", key, cursor])
}
