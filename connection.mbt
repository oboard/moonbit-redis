// ============ 连接管理命令 ============

///|
pub async fn RedisClient::auth(
  self : RedisClient,
  password : String,
) -> RedisString {
  self.send(["AUTH", password]).to_string()
}

///|
pub async fn RedisClient::auth_username(
  self : RedisClient,
  username : String,
  password : String,
) -> RedisString {
  self.send(["AUTH", username, password]).to_string()
}

///|
pub async fn RedisClient::echo(
  self : RedisClient,
  message : String,
) -> RedisString {
  self.send(["ECHO", message]).to_string()
}

///|
pub async fn RedisClient::hello(
  self : RedisClient,
  protover : String,
) -> RedisArray {
  self.send(["HELLO", protover]).to_array()
}

///|
pub async fn RedisClient::quit(self : RedisClient) -> RedisString {
  self.send(["QUIT"]).to_string()
}

///|
pub async fn RedisClient::reset(self : RedisClient) -> RedisString {
  self.send(["RESET"]).to_string()
}

///|
pub async fn RedisClient::select(
  self : RedisClient,
  index : String,
) -> RedisString {
  self.send(["SELECT", index]).to_string()
}

///|
pub async fn RedisClient::client_caching(
  self : RedisClient,
  mode : String,
) -> RedisString {
  self.send(["CLIENT", "CACHING", mode]).to_string()
}

///|
pub async fn RedisClient::client_getname(self : RedisClient) -> RedisBulkString {
  self.send(["CLIENT", "GETNAME"]).to_bulk_string()
}

///|
pub async fn RedisClient::client_getredir(self : RedisClient) -> RedisInt {
  self.send(["CLIENT", "GETREDIR"]).to_int()
}

///|
pub async fn RedisClient::client_id(self : RedisClient) -> RedisInt {
  self.send(["CLIENT", "ID"]).to_int()
}

///|
pub async fn RedisClient::client_info(self : RedisClient) -> RedisString {
  self.send(["CLIENT", "INFO"]).to_string()
}

///|
pub async fn RedisClient::client_kill(
  self : RedisClient,
  ip_port : String,
) -> RedisInt {
  self.send(["CLIENT", "KILL", ip_port]).to_int()
}

///|
pub async fn RedisClient::client_list(self : RedisClient) -> RedisString {
  self.send(["CLIENT", "LIST"]).to_string()
}

///|
pub async fn RedisClient::client_no_evict(
  self : RedisClient,
  mode : String,
) -> RedisString {
  self.send(["CLIENT", "NO-EVICT", mode]).to_string()
}

///|
pub async fn RedisClient::client_no_touch(
  self : RedisClient,
  mode : String,
) -> RedisString {
  self.send(["CLIENT", "NO-TOUCH", mode]).to_string()
}

///|
pub async fn RedisClient::client_pause(
  self : RedisClient,
  timeout : String,
) -> RedisString {
  self.send(["CLIENT", "PAUSE", timeout]).to_string()
}

///|
pub async fn RedisClient::client_reply(
  self : RedisClient,
  mode : String,
) -> RedisString {
  self.send(["CLIENT", "REPLY", mode]).to_string()
}

///|
pub async fn RedisClient::client_setname(
  self : RedisClient,
  connection_name : String,
) -> RedisString {
  self.send(["CLIENT", "SETNAME", connection_name]).to_string()
}

///|
pub async fn RedisClient::client_tracking(
  self : RedisClient,
  mode : String,
) -> RedisString {
  self.send(["CLIENT", "TRACKING", mode]).to_string()
}

///|
pub async fn RedisClient::client_trackinginfo(self : RedisClient) -> RedisArray {
  self.send(["CLIENT", "TRACKINGINFO"]).to_array()
}

///|
pub async fn RedisClient::client_unblock(
  self : RedisClient,
  client_id : String,
) -> RedisInt {
  self.send(["CLIENT", "UNBLOCK", client_id]).to_int()
}

///|
pub async fn RedisClient::client_unpause(self : RedisClient) -> RedisString {
  self.send(["CLIENT", "UNPAUSE"]).to_string()
}
