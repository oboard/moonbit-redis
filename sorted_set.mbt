// ============ 有序集合命令 ============

///|
pub async fn RedisClient::zadd(
  self : RedisClient,
  key : String,
  score : String,
  value : String,
) -> String {
  self.send(["ZADD", key, score, value])
  self.read_response()
}

///|
pub async fn RedisClient::zrem(
  self : RedisClient,
  key : String,
  members : Array[String],
) -> String {
  let args = ["ZREM", key, ..members]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::zrange(
  self : RedisClient,
  key : String,
  start : String,
  stop : String,
) -> String {
  self.send(["ZRANGE", key, start, stop])
  self.read_response()
}

///|
pub async fn RedisClient::zrangebyscore(
  self : RedisClient,
  key : String,
  min : String,
  max : String,
) -> String {
  self.send(["ZRANGEBYSCORE", key, min, max])
  self.read_response()
}

///|
pub async fn RedisClient::zrangebylex(
  self : RedisClient,
  key : String,
  min : String,
  max : String,
) -> String {
  self.send(["ZRANGEBYLEX", key, min, max])
  self.read_response()
}

///|
pub async fn RedisClient::zrevrange(
  self : RedisClient,
  key : String,
  start : String,
  stop : String,
) -> String {
  self.send(["ZREVRANGE", key, start, stop])
  self.read_response()
}

///|
pub async fn RedisClient::zrevrangebyscore(
  self : RedisClient,
  key : String,
  max : String,
  min : String,
) -> String {
  self.send(["ZREVRANGEBYSCORE", key, max, min])
  self.read_response()
}

///|
pub async fn RedisClient::zrevrangebylex(
  self : RedisClient,
  key : String,
  max : String,
  min : String,
) -> String {
  self.send(["ZREVRANGEBYLEX", key, max, min])
  self.read_response()
}

///|
pub async fn RedisClient::zrangestore(
  self : RedisClient,
  dst : String,
  src : String,
  min : String,
  max : String,
) -> String {
  self.send(["ZRANGESTORE", dst, src, min, max])
  self.read_response()
}

///|
pub async fn RedisClient::zscore(
  self : RedisClient,
  key : String,
  value : String,
) -> String {
  self.send(["ZSCORE", key, value])
  self.read_response()
}

///|
pub async fn RedisClient::zmscore(
  self : RedisClient,
  key : String,
  members : Array[String],
) -> String {
  let args = ["ZMSCORE", key, ..members]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::zcard(self : RedisClient, key : String) -> String {
  self.send(["ZCARD", key])
  self.read_response()
}

///|
pub async fn RedisClient::zcount(
  self : RedisClient,
  key : String,
  min : String,
  max : String,
) -> String {
  self.send(["ZCOUNT", key, min, max])
  self.read_response()
}

///|
pub async fn RedisClient::zlexcount(
  self : RedisClient,
  key : String,
  min : String,
  max : String,
) -> String {
  self.send(["ZLEXCOUNT", key, min, max])
  self.read_response()
}

///|
pub async fn RedisClient::zrank(
  self : RedisClient,
  key : String,
  value : String,
) -> String {
  self.send(["ZRANK", key, value])
  self.read_response()
}

///|
pub async fn RedisClient::zrevrank(
  self : RedisClient,
  key : String,
  value : String,
) -> String {
  self.send(["ZREVRANK", key, value])
  self.read_response()
}

///|
pub async fn RedisClient::zincrby(
  self : RedisClient,
  key : String,
  increment : String,
  value : String,
) -> String {
  self.send(["ZINCRBY", key, increment, value])
  self.read_response()
}

///|
pub async fn RedisClient::zpopmax(self : RedisClient, key : String) -> String {
  self.send(["ZPOPMAX", key])
  self.read_response()
}

///|
pub async fn RedisClient::zpopmin(self : RedisClient, key : String) -> String {
  self.send(["ZPOPMIN", key])
  self.read_response()
}

///|
pub async fn RedisClient::bzpopmax(
  self : RedisClient,
  keys : Array[String],
  timeout : String,
) -> String {
  let args = ["BZPOPMAX", ..keys, timeout]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::bzpopmin(
  self : RedisClient,
  keys : Array[String],
  timeout : String,
) -> String {
  let args = ["BZPOPMIN", ..keys, timeout]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::zrandmember(
  self : RedisClient,
  key : String,
) -> String {
  self.send(["ZRANDMEMBER", key])
  self.read_response()
}

///|
pub async fn RedisClient::zremrangebyrank(
  self : RedisClient,
  key : String,
  start : String,
  stop : String,
) -> String {
  self.send(["ZREMRANGEBYRANK", key, start, stop])
  self.read_response()
}

///|
pub async fn RedisClient::zremrangebyscore(
  self : RedisClient,
  key : String,
  min : String,
  max : String,
) -> String {
  self.send(["ZREMRANGEBYSCORE", key, min, max])
  self.read_response()
}

///|
pub async fn RedisClient::zremrangebylex(
  self : RedisClient,
  key : String,
  min : String,
  max : String,
) -> String {
  self.send(["ZREMRANGEBYLEX", key, min, max])
  self.read_response()
}

///|
pub async fn RedisClient::zunion(
  self : RedisClient,
  numkeys : String,
  keys : Array[String],
) -> String {
  let args = ["ZUNION", numkeys, ..keys]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::zunionstore(
  self : RedisClient,
  destination : String,
  numkeys : String,
  keys : Array[String],
) -> String {
  let args = ["ZUNIONSTORE", destination, numkeys, ..keys]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::zinter(
  self : RedisClient,
  numkeys : String,
  keys : Array[String],
) -> String {
  let args = ["ZINTER", numkeys, ..keys]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::zintercard(
  self : RedisClient,
  numkeys : String,
  keys : Array[String],
) -> String {
  let args = ["ZINTERCARD", numkeys, ..keys]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::zinterstore(
  self : RedisClient,
  destination : String,
  numkeys : String,
  keys : Array[String],
) -> String {
  let args = ["ZINTERSTORE", destination, numkeys, ..keys]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::zdiff(
  self : RedisClient,
  numkeys : String,
  keys : Array[String],
) -> String {
  let args = ["ZDIFF", numkeys, ..keys]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::zdiffstore(
  self : RedisClient,
  destination : String,
  numkeys : String,
  keys : Array[String],
) -> String {
  let args = ["ZDIFFSTORE", destination, numkeys, ..keys]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::zmpop(
  self : RedisClient,
  numkeys : String,
  keys : Array[String],
  value : String,
) -> String {
  let args = ["ZMPOP", numkeys, ..keys, value]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::bzmpop(
  self : RedisClient,
  timeout : String,
  numkeys : String,
  keys : Array[String],
  where_ : String,
  count : String?, // optional COUNT argument
) -> String {
  let args = match count {
    Some(c) => ["BZMPOP", timeout, numkeys, ..keys, where_, "COUNT", c]
    None => ["BZMPOP", timeout, numkeys, ..keys, where_]
  }
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::zscan(
  self : RedisClient,
  key : String,
  cursor : String,
) -> String {
  self.send(["ZSCAN", key, cursor])
  self.read_response()
}
