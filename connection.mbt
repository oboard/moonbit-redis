// ============ 连接管理命令 ============

///|
pub async fn RedisClient::auth(self : RedisClient, password : String) -> String {
  self.send(["AUTH", password])
  self.read_response()
}

///|
pub async fn RedisClient::auth_username(
  self : RedisClient,
  username : String,
  password : String,
) -> String {
  self.send(["AUTH", username, password])
  self.read_response()
}

///|
pub async fn RedisClient::echo(self : RedisClient, message : String) -> String {
  self.send(["ECHO", message])
  self.read_response()
}

///|
pub async fn RedisClient::hello(
  self : RedisClient,
  protover : String,
) -> String {
  self.send(["HELLO", protover])
  self.read_response()
}

///|
pub async fn RedisClient::quit(self : RedisClient) -> String {
  self.send(["QUIT"])
  self.read_response()
}

///|
pub async fn RedisClient::reset(self : RedisClient) -> String {
  self.send(["RESET"])
  self.read_response()
}

///|
pub async fn RedisClient::select(self : RedisClient, index : String) -> String {
  self.send(["SELECT", index])
  self.read_response()
}

///|
pub async fn RedisClient::client_caching(
  self : RedisClient,
  mode : String,
) -> String {
  self.send(["CLIENT", "CACHING", mode])
  self.read_response()
}

///|
pub async fn RedisClient::client_getname(self : RedisClient) -> String {
  self.send(["CLIENT", "GETNAME"])
  self.read_response()
}

///|
pub async fn RedisClient::client_getredir(self : RedisClient) -> String {
  self.send(["CLIENT", "GETREDIR"])
  self.read_response()
}

///|
pub async fn RedisClient::client_id(self : RedisClient) -> String {
  self.send(["CLIENT", "ID"])
  self.read_response()
}

///|
pub async fn RedisClient::client_info(self : RedisClient) -> String {
  self.send(["CLIENT", "INFO"])
  self.read_response()
}

///|
pub async fn RedisClient::client_kill(
  self : RedisClient,
  ip_port : String,
) -> String {
  self.send(["CLIENT", "KILL", ip_port])
  self.read_response()
}

///|
pub async fn RedisClient::client_list(self : RedisClient) -> String {
  self.send(["CLIENT", "LIST"])
  self.read_response()
}

///|
pub async fn RedisClient::client_no_evict(
  self : RedisClient,
  mode : String,
) -> String {
  self.send(["CLIENT", "NO-EVICT", mode])
  self.read_response()
}

///|
pub async fn RedisClient::client_no_touch(
  self : RedisClient,
  mode : String,
) -> String {
  self.send(["CLIENT", "NO-TOUCH", mode])
  self.read_response()
}

///|
pub async fn RedisClient::client_pause(
  self : RedisClient,
  timeout : String,
) -> String {
  self.send(["CLIENT", "PAUSE", timeout])
  self.read_response()
}

///|
pub async fn RedisClient::client_reply(
  self : RedisClient,
  mode : String,
) -> String {
  self.send(["CLIENT", "REPLY", mode])
  self.read_response()
}

///|
pub async fn RedisClient::client_setname(
  self : RedisClient,
  connection_name : String,
) -> String {
  self.send(["CLIENT", "SETNAME", connection_name])
  self.read_response()
}

///|
pub async fn RedisClient::client_tracking(
  self : RedisClient,
  mode : String,
) -> String {
  self.send(["CLIENT", "TRACKING", mode])
  self.read_response()
}

///|
pub async fn RedisClient::client_trackinginfo(self : RedisClient) -> String {
  self.send(["CLIENT", "TRACKINGINFO"])
  self.read_response()
}

///|
pub async fn RedisClient::client_unblock(
  self : RedisClient,
  client_id : String,
) -> String {
  self.send(["CLIENT", "UNBLOCK", client_id])
  self.read_response()
}

///|
pub async fn RedisClient::client_unpause(self : RedisClient) -> String {
  self.send(["CLIENT", "UNPAUSE"])
  self.read_response()
}
