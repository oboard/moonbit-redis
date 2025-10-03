// ============ 通用命令 ============

///|
pub async fn RedisClient::del(
  self : RedisClient,
  keys : Array[String],
) -> String {
  let args = ["DEL", ..keys]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::unlink(
  self : RedisClient,
  keys : Array[String],
) -> String {
  let args = ["UNLINK", ..keys]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::exists(
  self : RedisClient,
  keys : Array[String],
) -> String {
  let args = ["EXISTS", ..keys]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::expire(
  self : RedisClient,
  key : String,
  seconds : String,
) -> String {
  self.send(["EXPIRE", key, seconds])
  self.read_response()
}

///|
pub async fn RedisClient::expireat(
  self : RedisClient,
  key : String,
  timestamp : String,
) -> String {
  self.send(["EXPIREAT", key, timestamp])
  self.read_response()
}

///|
pub async fn RedisClient::expiretime(
  self : RedisClient,
  key : String,
) -> String {
  self.send(["EXPIRETIME", key])
  self.read_response()
}

///|
pub async fn RedisClient::pexpire(
  self : RedisClient,
  key : String,
  milliseconds : String,
) -> String {
  self.send(["PEXPIRE", key, milliseconds])
  self.read_response()
}

///|
pub async fn RedisClient::pexpireat(
  self : RedisClient,
  key : String,
  timestamp : String,
) -> String {
  self.send(["PEXPIREAT", key, timestamp])
  self.read_response()
}

///|
pub async fn RedisClient::pexpiretime(
  self : RedisClient,
  key : String,
) -> String {
  self.send(["PEXPIRETIME", key])
  self.read_response()
}

///|
pub async fn RedisClient::ttl(self : RedisClient, key : String) -> String {
  self.send(["TTL", key])
  self.read_response()
}

///|
pub async fn RedisClient::pttl(self : RedisClient, key : String) -> String {
  self.send(["PTTL", key])
  self.read_response()
}

///|
pub async fn RedisClient::persist(self : RedisClient, key : String) -> String {
  self.send(["PERSIST", key])
  self.read_response()
}

///|
pub async fn RedisClient::keys(self : RedisClient, pattern : String) -> String {
  self.send(["KEYS", pattern])
  self.read_response()
}

///|
pub async fn RedisClient::scan(self : RedisClient, cursor : String) -> String {
  self.send(["SCAN", cursor])
  self.read_response()
}

///|
pub async fn RedisClient::randomkey(self : RedisClient) -> String {
  self.send(["RANDOMKEY"])
  self.read_response()
}

///|
pub async fn RedisClient::rename(
  self : RedisClient,
  key : String,
  newkey : String,
) -> String {
  self.send(["RENAME", key, newkey])
  self.read_response()
}

///|
pub async fn RedisClient::renamenx(
  self : RedisClient,
  key : String,
  newkey : String,
) -> String {
  self.send(["RENAMENX", key, newkey])
  self.read_response()
}

///|
pub async fn RedisClient::type_(self : RedisClient, key : String) -> String {
  self.send(["TYPE", key])
  self.read_response()
}

///|
pub async fn RedisClient::sort(self : RedisClient, key : String) -> String {
  self.send(["SORT", key])
  self.read_response()
}

///|
pub async fn RedisClient::sort_ro(self : RedisClient, key : String) -> String {
  self.send(["SORT_RO", key])
  self.read_response()
}

///|
pub async fn RedisClient::copy(
  self : RedisClient,
  source : String,
  destination : String,
) -> String {
  self.send(["COPY", source, destination])
  self.read_response()
}

///|
pub async fn RedisClient::move_(
  self : RedisClient,
  key : String,
  db : String,
) -> String {
  self.send(["MOVE", key, db])
  self.read_response()
}

///|
pub async fn RedisClient::swapdb(
  self : RedisClient,
  index1 : String,
  index2 : String,
) -> String {
  self.send(["SWAPDB", index1, index2])
  self.read_response()
}

///|
pub async fn RedisClient::touch(
  self : RedisClient,
  keys : Array[String],
) -> String {
  let args = ["TOUCH", ..keys]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::dump(self : RedisClient, key : String) -> String {
  self.send(["DUMP", key])
  self.read_response()
}

///|
pub async fn RedisClient::restore(
  self : RedisClient,
  key : String,
  ttl : String,
  serialized_value : String,
) -> String {
  self.send(["RESTORE", key, ttl, serialized_value])
  self.read_response()
}

///|
pub async fn RedisClient::migrate(
  self : RedisClient,
  host : String,
  port : String,
  key : String,
  destination_db : String,
  timeout : String,
) -> String {
  self.send(["MIGRATE", host, port, key, destination_db, timeout])
  self.read_response()
}

///|
pub async fn RedisClient::object_encoding(
  self : RedisClient,
  key : String,
) -> String {
  self.send(["OBJECT", "ENCODING", key])
  self.read_response()
}

///|
pub async fn RedisClient::object_freq(
  self : RedisClient,
  key : String,
) -> String {
  self.send(["OBJECT", "FREQ", key])
  self.read_response()
}

///|
pub async fn RedisClient::object_idletime(
  self : RedisClient,
  key : String,
) -> String {
  self.send(["OBJECT", "IDLETIME", key])
  self.read_response()
}

///|
pub async fn RedisClient::object_refcount(
  self : RedisClient,
  key : String,
) -> String {
  self.send(["OBJECT", "REFCOUNT", key])
  self.read_response()
}

///|
pub async fn RedisClient::flushdb(self : RedisClient) -> String {
  self.send(["FLUSHDB"])
  self.read_response()
}

///|
pub async fn RedisClient::flushall(self : RedisClient) -> String {
  self.send(["FLUSHALL"])
  self.read_response()
}

///|
pub async fn RedisClient::dbsize(self : RedisClient) -> String {
  self.send(["DBSIZE"])
  self.read_response()
}

///|
pub async fn RedisClient::wait(
  self : RedisClient,
  numreplicas : String,
  timeout : String,
) -> String {
  self.send(["WAIT", numreplicas, timeout])
  self.read_response()
}

///|
pub async fn RedisClient::waitaof(
  self : RedisClient,
  numlocal : String,
  numreplicas : String,
  timeout : String,
) -> String {
  self.send(["WAITAOF", numlocal, numreplicas, timeout])
  self.read_response()
}
