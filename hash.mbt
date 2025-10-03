// ============ 哈希命令 ============

///|
pub async fn RedisClient::hset(
  self : RedisClient,
  key : String,
  field : String,
  value : String,
) -> RedisInt {
  self.send(["HSET", key, field, value]).to_int()
}

///|
pub async fn RedisClient::hget(
  self : RedisClient,
  key : String,
  field : String,
) -> RedisString {
  self.send(["HGET", key, field]).to_string()
}

///|
pub async fn RedisClient::hdel(
  self : RedisClient,
  key : String,
  fields : Array[String],
) -> RedisInt {
  let args = ["HDEL", key, ..fields]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::hkeys(self : RedisClient, key : String) -> RedisArray {
  self.send(["HKEYS", key]).to_array()
}

///|
pub async fn RedisClient::hvals(self : RedisClient, key : String) -> RedisArray {
  self.send(["HVALS", key]).to_array()
}

///|
pub async fn RedisClient::hgetall(
  self : RedisClient,
  key : String,
) -> RedisHash {
  let redis_value = self.send(["HGETALL", key])
  match redis_value.to_array() {
    Ok(arr) => {
      // 将平坦数组转换为键值对
      let pairs = Map::new()
      let mut i = 0
      while i < arr.length() - 1 {
        pairs.set(arr[i], arr[i + 1])
        i = i + 2
      }
      Ok(pairs)
    }
    Err(e) => Err(e)
  }
}

///|
pub async fn RedisClient::hexists(
  self : RedisClient,
  key : String,
  field : String,
) -> RedisBool {
  self.send(["HEXISTS", key, field]).to_bool()
}

///|
pub async fn RedisClient::hlen(self : RedisClient, key : String) -> RedisInt {
  self.send(["HLEN", key]).to_int()
}
