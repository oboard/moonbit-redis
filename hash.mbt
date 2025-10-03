// ============ 哈希命令 ============

///|
pub async fn RedisClient::hset(
  self : RedisClient,
  key : String,
  field : String,
  value : String,
) -> RedisInt {
  self.send(["HSET", key, field, value])
  self.read_redis_value().to_int()
}

///|
/// HSET命令的原始字符串版本（向后兼容）
pub async fn RedisClient::hset_raw(
  self : RedisClient,
  key : String,
  field : String,
  value : String,
) -> String {
  self.send(["HSET", key, field, value])
  self.read_response()
}

///|
pub async fn RedisClient::hget(
  self : RedisClient,
  key : String,
  field : String,
) -> RedisString {
  self.send(["HGET", key, field])
  self.read_redis_value().to_string()
}

///|
/// HGET命令的原始字符串版本（向后兼容）
pub async fn RedisClient::hget_raw(
  self : RedisClient,
  key : String,
  field : String,
) -> String {
  self.send(["HGET", key, field])
  self.read_response()
}

///|
pub async fn RedisClient::hdel(
  self : RedisClient,
  key : String,
  fields : Array[String],
) -> RedisInt {
  let args = ["HDEL", key, ..fields]
  self.send(args)
  self.read_redis_value().to_int()
}

///|
/// HDEL命令的原始字符串版本（向后兼容）
pub async fn RedisClient::hdel_raw(
  self : RedisClient,
  key : String,
  fields : Array[String],
) -> String {
  let args = ["HDEL", key, ..fields]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::hkeys(self : RedisClient, key : String) -> RedisArray {
  self.send(["HKEYS", key])
  self.read_redis_value().to_array()
}

///|
/// HKEYS命令的原始字符串版本（向后兼容）
pub async fn RedisClient::hkeys_raw(self : RedisClient, key : String) -> String {
  self.send(["HKEYS", key])
  self.read_response()
}

///|
pub async fn RedisClient::hvals(self : RedisClient, key : String) -> RedisArray {
  self.send(["HVALS", key])
  self.read_redis_value().to_array()
}

///|
/// HVALS命令的原始字符串版本（向后兼容）
pub async fn RedisClient::hvals_raw(self : RedisClient, key : String) -> String {
  self.send(["HVALS", key])
  self.read_response()
}

///|
pub async fn RedisClient::hgetall(
  self : RedisClient,
  key : String,
) -> RedisHash {
  self.send(["HGETALL", key])
  let redis_value = self.read_redis_value()
  match redis_value.to_array() {
    Result::Ok(arr) => {
      // 将平坦数组转换为键值对
      let pairs = Array::new()
      let mut i = 0
      while i < arr.length() - 1 {
        pairs.push((arr[i], arr[i + 1]))
        i = i + 2
      }
      Result::Ok(pairs)
    }
    Result::Err(e) => Result::Err(e)
  }
}

///|
/// HGETALL命令的原始字符串版本（向后兼容）
pub async fn RedisClient::hgetall_raw(
  self : RedisClient,
  key : String,
) -> String {
  self.send(["HGETALL", key])
  self.read_response()
}

///|
pub async fn RedisClient::hexists(
  self : RedisClient,
  key : String,
  field : String,
) -> RedisBool {
  self.send(["HEXISTS", key, field])
  self.read_redis_value().to_bool()
}

///|
/// HEXISTS命令的原始字符串版本（向后兼容）
pub async fn RedisClient::hexists_raw(
  self : RedisClient,
  key : String,
  field : String,
) -> String {
  self.send(["HEXISTS", key, field])
  self.read_response()
}

///|
pub async fn RedisClient::hlen(self : RedisClient, key : String) -> RedisInt {
  self.send(["HLEN", key])
  self.read_redis_value().to_int()
}

///|
/// HLEN命令的原始字符串版本（向后兼容）
pub async fn RedisClient::hlen_raw(self : RedisClient, key : String) -> String {
  self.send(["HLEN", key])
  self.read_response()
}
