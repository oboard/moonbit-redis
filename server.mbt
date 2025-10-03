// ============ 服务器管理命令 ============

///|
pub async fn RedisClient::bgrewriteaof(self : RedisClient) -> String {
  self.send(["BGREWRITEAOF"])
  self.read_response()
}

///|
pub async fn RedisClient::bgsave(self : RedisClient) -> String {
  self.send(["BGSAVE"])
  self.read_response()
}

///|
pub async fn RedisClient::command(self : RedisClient) -> String {
  self.send(["COMMAND"])
  self.read_response()
}

///|
pub async fn RedisClient::command_count(self : RedisClient) -> String {
  self.send(["COMMAND", "COUNT"])
  self.read_response()
}

///|
pub async fn RedisClient::command_docs(
  self : RedisClient,
  command_names : Array[String],
) -> String {
  let args = ["COMMAND", "DOCS", ..command_names]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::command_getkeys(
  self : RedisClient,
  command : Array[String],
) -> String {
  let args = ["COMMAND", "GETKEYS", ..command]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::command_getkeysandflags(
  self : RedisClient,
  command : Array[String],
) -> String {
  let args = ["COMMAND", "GETKEYSANDFLAGS", ..command]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::command_info(
  self : RedisClient,
  command_names : Array[String],
) -> String {
  let args = ["COMMAND", "INFO", ..command_names]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::command_list(self : RedisClient) -> String {
  self.send(["COMMAND", "LIST"])
  self.read_response()
}

///|
pub async fn RedisClient::config_get(
  self : RedisClient,
  parameter : String,
) -> String {
  self.send(["CONFIG", "GET", parameter])
  self.read_response()
}

///|
pub async fn RedisClient::config_resetstat(self : RedisClient) -> String {
  self.send(["CONFIG", "RESETSTAT"])
  self.read_response()
}

///|
pub async fn RedisClient::config_rewrite(self : RedisClient) -> String {
  self.send(["CONFIG", "REWRITE"])
  self.read_response()
}

///|
pub async fn RedisClient::config_set(
  self : RedisClient,
  parameter : String,
  value : String,
) -> String {
  self.send(["CONFIG", "SET", parameter, value])
  self.read_response()
}

///|
pub async fn RedisClient::debug_object(
  self : RedisClient,
  key : String,
) -> String {
  self.send(["DEBUG", "OBJECT", key])
  self.read_response()
}

///|
pub async fn RedisClient::debug_segfault(self : RedisClient) -> String {
  self.send(["DEBUG", "SEGFAULT"])
  self.read_response()
}

///|
pub async fn RedisClient::info(self : RedisClient) -> String {
  self.send(["INFO"])
  self.read_response()
}

///|
pub async fn RedisClient::info_section(
  self : RedisClient,
  section : String,
) -> String {
  self.send(["INFO", section])
  self.read_response()
}

///|
pub async fn RedisClient::lastsave(self : RedisClient) -> String {
  self.send(["LASTSAVE"])
  self.read_response()
}

///|
pub async fn RedisClient::latency_doctor(self : RedisClient) -> String {
  self.send(["LATENCY", "DOCTOR"])
  self.read_response()
}

///|
pub async fn RedisClient::latency_graph(
  self : RedisClient,
  event : String,
) -> String {
  self.send(["LATENCY", "GRAPH", event])
  self.read_response()
}

///|
pub async fn RedisClient::latency_history(
  self : RedisClient,
  event : String,
) -> String {
  self.send(["LATENCY", "HISTORY", event])
  self.read_response()
}

///|
pub async fn RedisClient::latency_latest(self : RedisClient) -> String {
  self.send(["LATENCY", "LATEST"])
  self.read_response()
}

///|
pub async fn RedisClient::latency_reset(
  self : RedisClient,
  events : Array[String],
) -> String {
  let args = ["LATENCY", "RESET", ..events]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::memory_doctor(self : RedisClient) -> String {
  self.send(["MEMORY", "DOCTOR"])
  self.read_response()
}

///|
pub async fn RedisClient::memory_malloc_stats(self : RedisClient) -> String {
  self.send(["MEMORY", "MALLOC-STATS"])
  self.read_response()
}

///|
pub async fn RedisClient::memory_purge(self : RedisClient) -> String {
  self.send(["MEMORY", "PURGE"])
  self.read_response()
}

///|
pub async fn RedisClient::memory_stats(self : RedisClient) -> String {
  self.send(["MEMORY", "STATS"])
  self.read_response()
}

///|
pub async fn RedisClient::memory_usage(
  self : RedisClient,
  key : String,
) -> String {
  self.send(["MEMORY", "USAGE", key])
  self.read_response()
}

///|
pub async fn RedisClient::module_list(self : RedisClient) -> String {
  self.send(["MODULE", "LIST"])
  self.read_response()
}

///|
pub async fn RedisClient::module_load(
  self : RedisClient,
  path : String,
) -> String {
  self.send(["MODULE", "LOAD", path])
  self.read_response()
}

///|
pub async fn RedisClient::module_loadex(
  self : RedisClient,
  path : String,
  args : Array[String],
) -> String {
  let command_args = ["MODULE", "LOADEX", path, ..args]
  self.send(command_args)
  self.read_response()
}

///|
pub async fn RedisClient::module_unload(
  self : RedisClient,
  name : String,
) -> String {
  self.send(["MODULE", "UNLOAD", name])
  self.read_response()
}

///|
pub async fn RedisClient::monitor(self : RedisClient) -> String {
  self.send(["MONITOR"])
  self.read_response()
}

///|
pub async fn RedisClient::psync(
  self : RedisClient,
  replicationid : String,
  offset : String,
) -> String {
  self.send(["PSYNC", replicationid, offset])
  self.read_response()
}

///|
pub async fn RedisClient::replconf(
  self : RedisClient,
  option : String,
  value : String,
) -> String {
  self.send(["REPLCONF", option, value])
  self.read_response()
}

///|
pub async fn RedisClient::replicaof(
  self : RedisClient,
  host : String,
  port : String,
) -> String {
  self.send(["REPLICAOF", host, port])
  self.read_response()
}

///|
pub async fn RedisClient::role(self : RedisClient) -> String {
  self.send(["ROLE"])
  self.read_response()
}

///|
pub async fn RedisClient::save(self : RedisClient) -> String {
  self.send(["SAVE"])
  self.read_response()
}

///|
pub async fn RedisClient::shutdown(self : RedisClient) -> String {
  self.send(["SHUTDOWN"])
  self.read_response()
}

///|
pub async fn RedisClient::slaveof(
  self : RedisClient,
  host : String,
  port : String,
) -> String {
  self.send(["SLAVEOF", host, port])
  self.read_response()
}

///|
pub async fn RedisClient::slowlog_get(self : RedisClient) -> String {
  self.send(["SLOWLOG", "GET"])
  self.read_response()
}

///|
pub async fn RedisClient::slowlog_len(self : RedisClient) -> String {
  self.send(["SLOWLOG", "LEN"])
  self.read_response()
}

///|
pub async fn RedisClient::slowlog_reset(self : RedisClient) -> String {
  self.send(["SLOWLOG", "RESET"])
  self.read_response()
}

///|
pub async fn RedisClient::sync(self : RedisClient) -> String {
  self.send(["SYNC"])
  self.read_response()
}

///|
pub async fn RedisClient::time(self : RedisClient) -> String {
  self.send(["TIME"])
  self.read_response()
}
