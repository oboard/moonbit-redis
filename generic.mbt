// ============ 通用命令 ============

///|
pub async fn RedisClient::del(
  self : RedisClient,
  keys : Array[String],
) -> RedisInt {
  let args = ["DEL", ..keys]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::unlink(
  self : RedisClient,
  keys : Array[String],
) -> RedisInt {
  let args = ["UNLINK", ..keys]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::exists(
  self : RedisClient,
  keys : Array[String],
) -> RedisInt {
  let args = ["EXISTS", ..keys]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::expire(
  self : RedisClient,
  key : String,
  seconds : String,
) -> RedisInt {
  self.send(["EXPIRE", key, seconds]).to_int()
}

///|
pub async fn RedisClient::expireat(
  self : RedisClient,
  key : String,
  timestamp : String,
) -> RedisInt {
  self.send(["EXPIREAT", key, timestamp]).to_int()
}

///|
pub async fn RedisClient::expiretime(
  self : RedisClient,
  key : String,
) -> RedisInt {
  self.send(["EXPIRETIME", key]).to_int()
}

///|
pub async fn RedisClient::pexpire(
  self : RedisClient,
  key : String,
  milliseconds : String,
) -> RedisInt {
  self.send(["PEXPIRE", key, milliseconds]).to_int()
}

///|
pub async fn RedisClient::pexpireat(
  self : RedisClient,
  key : String,
  timestamp : String,
) -> RedisInt {
  self.send(["PEXPIREAT", key, timestamp]).to_int()
}

///|
pub async fn RedisClient::pexpiretime(
  self : RedisClient,
  key : String,
) -> RedisInt {
  self.send(["PEXPIRETIME", key]).to_int()
}

///|
pub async fn RedisClient::ttl(self : RedisClient, key : String) -> RedisInt {
  self.send(["TTL", key]).to_int()
}

///|
pub async fn RedisClient::pttl(self : RedisClient, key : String) -> RedisInt {
  self.send(["PTTL", key]).to_int()
}

///|
pub async fn RedisClient::persist(self : RedisClient, key : String) -> RedisInt {
  self.send(["PERSIST", key]).to_int()
}

///|
pub async fn RedisClient::keys(
  self : RedisClient,
  pattern : String,
) -> RedisArray {
  self.send(["KEYS", pattern]).to_array()
}

///|
pub async fn RedisClient::scan(
  self : RedisClient,
  cursor : String,
) -> RedisArray {
  self.send(["SCAN", cursor]).to_array()
}

///|
pub async fn RedisClient::randomkey(self : RedisClient) -> RedisBulkString {
  self.send(["RANDOMKEY"]).to_bulk_string()
}

///|
pub async fn RedisClient::rename(
  self : RedisClient,
  key : String,
  newkey : String,
) -> RedisString {
  self.send(["RENAME", key, newkey]).to_string()
}

///|
pub async fn RedisClient::renamenx(
  self : RedisClient,
  key : String,
  newkey : String,
) -> RedisInt {
  self.send(["RENAMENX", key, newkey]).to_int()
}

///|
pub async fn RedisClient::type_(
  self : RedisClient,
  key : String,
) -> RedisString {
  self.send(["TYPE", key]).to_string()
}

///|
pub async fn RedisClient::sort(self : RedisClient, key : String) -> RedisArray {
  self.send(["SORT", key]).to_array()
}

///|
pub async fn RedisClient::sort_ro(
  self : RedisClient,
  key : String,
) -> RedisArray {
  self.send(["SORT_RO", key]).to_array()
}

///|
pub async fn RedisClient::copy(
  self : RedisClient,
  source : String,
  destination : String,
) -> RedisInt {
  self.send(["COPY", source, destination]).to_int()
}

///|
pub async fn RedisClient::move_(
  self : RedisClient,
  key : String,
  db : String,
) -> RedisInt {
  self.send(["MOVE", key, db]).to_int()
}

///|
pub async fn RedisClient::swapdb(
  self : RedisClient,
  index1 : String,
  index2 : String,
) -> RedisString {
  self.send(["SWAPDB", index1, index2]).to_string()
}

///|
pub async fn RedisClient::touch(
  self : RedisClient,
  keys : Array[String],
) -> RedisInt {
  let args = ["TOUCH", ..keys]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::dump(
  self : RedisClient,
  key : String,
) -> RedisBulkString {
  self.send(["DUMP", key]).to_bulk_string()
}

///|
pub async fn RedisClient::restore(
  self : RedisClient,
  key : String,
  ttl : String,
  serialized_value : String,
) -> RedisString {
  self.send(["RESTORE", key, ttl, serialized_value]).to_string()
}

///|
pub async fn RedisClient::migrate(
  self : RedisClient,
  host : String,
  port : String,
  key : String,
  destination_db : String,
  timeout : String,
) -> RedisString {
  self.send(["MIGRATE", host, port, key, destination_db, timeout]).to_string()
}

///|
pub async fn RedisClient::object_encoding(
  self : RedisClient,
  key : String,
) -> RedisBulkString {
  self.send(["OBJECT", "ENCODING", key]).to_bulk_string()
}

///|
pub async fn RedisClient::object_freq(
  self : RedisClient,
  key : String,
) -> RedisInt {
  self.send(["OBJECT", "FREQ", key]).to_int()
}

///|
pub async fn RedisClient::object_idletime(
  self : RedisClient,
  key : String,
) -> RedisInt {
  self.send(["OBJECT", "IDLETIME", key]).to_int()
}

///|
pub async fn RedisClient::object_refcount(
  self : RedisClient,
  key : String,
) -> RedisInt {
  self.send(["OBJECT", "REFCOUNT", key]).to_int()
}

///|
pub async fn RedisClient::flushdb(self : RedisClient) -> RedisString {
  self.send(["FLUSHDB"]).to_string()
}

///|
pub async fn RedisClient::flushall(self : RedisClient) -> RedisString {
  self.send(["FLUSHALL"]).to_string()
}

///|
pub async fn RedisClient::dbsize(self : RedisClient) -> RedisInt {
  self.send(["DBSIZE"]).to_int()
}

///|
pub async fn RedisClient::wait(
  self : RedisClient,
  numreplicas : String,
  timeout : String,
) -> RedisInt {
  self.send(["WAIT", numreplicas, timeout]).to_int()
}

///|
pub async fn RedisClient::waitaof(
  self : RedisClient,
  numlocal : String,
  numreplicas : String,
  timeout : String,
) -> RedisInt {
  self.send(["WAITAOF", numlocal, numreplicas, timeout]).to_int()
}
