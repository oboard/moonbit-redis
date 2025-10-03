// ============ 服务器管理命令 ============

///|
pub async fn RedisClient::bgrewriteaof(self : RedisClient) -> RedisValue {
  self.send(["BGREWRITEAOF"])
}

///|
pub async fn RedisClient::bgsave(self : RedisClient) -> RedisValue {
  self.send(["BGSAVE"])
}

///|
pub async fn RedisClient::command(self : RedisClient) -> RedisValue {
  self.send(["COMMAND"])
}

///|
pub async fn RedisClient::command_count(self : RedisClient) -> RedisValue {
  self.send(["COMMAND", "COUNT"])
}

///|
pub async fn RedisClient::command_docs(
  self : RedisClient,
  command_names : Array[String],
) -> RedisValue {
  let args = ["COMMAND", "DOCS", ..command_names]
  self.send(args)
}

///|
pub async fn RedisClient::command_getkeys(
  self : RedisClient,
  command : Array[String],
) -> RedisValue {
  let args = ["COMMAND", "GETKEYS", ..command]
  self.send(args)
}

///|
pub async fn RedisClient::command_getkeysandflags(
  self : RedisClient,
  command : Array[String],
) -> RedisValue {
  let args = ["COMMAND", "GETKEYSANDFLAGS", ..command]
  self.send(args)
}

///|
pub async fn RedisClient::command_info(
  self : RedisClient,
  command_names : Array[String],
) -> RedisValue {
  let args = ["COMMAND", "INFO", ..command_names]
  self.send(args)
}

///|
pub async fn RedisClient::command_list(self : RedisClient) -> RedisValue {
  self.send(["COMMAND", "LIST"])
}

///|
pub async fn RedisClient::config_get(
  self : RedisClient,
  parameter : String,
) -> RedisValue {
  self.send(["CONFIG", "GET", parameter])
}

///|
pub async fn RedisClient::config_resetstat(self : RedisClient) -> RedisValue {
  self.send(["CONFIG", "RESETSTAT"])
}

///|
pub async fn RedisClient::config_rewrite(self : RedisClient) -> RedisValue {
  self.send(["CONFIG", "REWRITE"])
}

///|
pub async fn RedisClient::config_set(
  self : RedisClient,
  parameter : String,
  value : String,
) -> RedisValue {
  self.send(["CONFIG", "SET", parameter, value])
}

///|
pub async fn RedisClient::debug_object(
  self : RedisClient,
  key : String,
) -> RedisValue {
  self.send(["DEBUG", "OBJECT", key])
}

///|
pub async fn RedisClient::debug_segfault(self : RedisClient) -> RedisValue {
  self.send(["DEBUG", "SEGFAULT"])
}

///|
pub async fn RedisClient::info(self : RedisClient) -> RedisValue {
  self.send(["INFO"])
}

///|
pub async fn RedisClient::info_section(
  self : RedisClient,
  section : String,
) -> RedisValue {
  self.send(["INFO", section])
}

///|
pub async fn RedisClient::lastsave(self : RedisClient) -> RedisValue {
  self.send(["LASTSAVE"])
}

///|
pub async fn RedisClient::latency_doctor(self : RedisClient) -> RedisValue {
  self.send(["LATENCY", "DOCTOR"])
}

///|
pub async fn RedisClient::latency_graph(
  self : RedisClient,
  event : String,
) -> RedisValue {
  self.send(["LATENCY", "GRAPH", event])
}

///|
pub async fn RedisClient::latency_history(
  self : RedisClient,
  event : String,
) -> RedisValue {
  self.send(["LATENCY", "HISTORY", event])
}

///|
pub async fn RedisClient::latency_latest(self : RedisClient) -> RedisValue {
  self.send(["LATENCY", "LATEST"])
}

///|
pub async fn RedisClient::latency_reset(
  self : RedisClient,
  events : Array[String],
) -> RedisValue {
  let args = ["LATENCY", "RESET", ..events]
  self.send(args)
}

///|
pub async fn RedisClient::memory_doctor(self : RedisClient) -> RedisValue {
  self.send(["MEMORY", "DOCTOR"])
}

///|
pub async fn RedisClient::memory_malloc_stats(self : RedisClient) -> RedisValue {
  self.send(["MEMORY", "MALLOC-STATS"])
}

///|
pub async fn RedisClient::memory_purge(self : RedisClient) -> RedisValue {
  self.send(["MEMORY", "PURGE"])
}

///|
pub async fn RedisClient::memory_stats(self : RedisClient) -> RedisValue {
  self.send(["MEMORY", "STATS"])
}

///|
pub async fn RedisClient::memory_usage(
  self : RedisClient,
  key : String,
) -> RedisValue {
  self.send(["MEMORY", "USAGE", key])
}

///|
pub async fn RedisClient::module_list(self : RedisClient) -> RedisValue {
  self.send(["MODULE", "LIST"])
}

///|
pub async fn RedisClient::module_load(
  self : RedisClient,
  path : String,
) -> RedisValue {
  self.send(["MODULE", "LOAD", path])
}

///|
pub async fn RedisClient::module_loadex(
  self : RedisClient,
  path : String,
  args : Array[String],
) -> RedisValue {
  let command_args = ["MODULE", "LOADEX", path, ..args]
  self.send(command_args)
}

///|
pub async fn RedisClient::module_unload(
  self : RedisClient,
  name : String,
) -> RedisValue {
  self.send(["MODULE", "UNLOAD", name])
}

///|
pub async fn RedisClient::monitor(self : RedisClient) -> RedisValue {
  self.send(["MONITOR"])
}

///|
pub async fn RedisClient::psync(
  self : RedisClient,
  replicationid : String,
  offset : String,
) -> RedisValue {
  self.send(["PSYNC", replicationid, offset])
}

///|
pub async fn RedisClient::replconf(
  self : RedisClient,
  option : String,
  value : String,
) -> RedisValue {
  self.send(["REPLCONF", option, value])
}

///|
pub async fn RedisClient::replicaof(
  self : RedisClient,
  host : String,
  port : String,
) -> RedisValue {
  self.send(["REPLICAOF", host, port])
}

///|
pub async fn RedisClient::role(self : RedisClient) -> RedisValue {
  self.send(["ROLE"])
}

///|
pub async fn RedisClient::save(self : RedisClient) -> RedisValue {
  self.send(["SAVE"])
}

///|
pub async fn RedisClient::shutdown(self : RedisClient) -> RedisValue {
  self.send(["SHUTDOWN"])
}

///|
pub async fn RedisClient::slaveof(
  self : RedisClient,
  host : String,
  port : String,
) -> RedisValue {
  self.send(["SLAVEOF", host, port])
}

///|
pub async fn RedisClient::slowlog_get(self : RedisClient) -> RedisValue {
  self.send(["SLOWLOG", "GET"])
}

///|
pub async fn RedisClient::slowlog_len(self : RedisClient) -> RedisValue {
  self.send(["SLOWLOG", "LEN"])
}

///|
pub async fn RedisClient::slowlog_reset(self : RedisClient) -> RedisValue {
  self.send(["SLOWLOG", "RESET"])
}

///|
pub async fn RedisClient::sync(self : RedisClient) -> RedisValue {
  self.send(["SYNC"])
}

///|
pub async fn RedisClient::time(self : RedisClient) -> RedisValue {
  self.send(["TIME"])
}
