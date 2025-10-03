// ============ 集群命令 ============

///|
pub async fn RedisClient::cluster_addslots(
  self : RedisClient,
  slots : Array[Int],
) -> String {
  let slot_strings = slots.map(fn(slot) { slot.to_string() })
  let args = ["CLUSTER", "ADDSLOTS", ..slot_strings]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::cluster_addslotsrange(
  self : RedisClient,
  ranges : Array[(Int, Int)],
) -> String {
  let range_strings = Array::new()
  for range in ranges {
    let (start, end) = range
    range_strings.push(start.to_string())
    range_strings.push(end.to_string())
  }
  let args = ["CLUSTER", "ADDSLOTSRANGE", ..range_strings]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::cluster_bumpepoch(self : RedisClient) -> String {
  self.send(["CLUSTER", "BUMPEPOCH"])
  self.read_response()
}

///|
pub async fn RedisClient::cluster_count_failure_reports(
  self : RedisClient,
  node_id : String,
) -> String {
  self.send(["CLUSTER", "COUNT-FAILURE-REPORTS", node_id])
  self.read_response()
}

///|
pub async fn RedisClient::cluster_countkeysinslot(
  self : RedisClient,
  slot : Int,
) -> String {
  self.send(["CLUSTER", "COUNTKEYSINSLOT", slot.to_string()])
  self.read_response()
}

///|
pub async fn RedisClient::cluster_delslots(
  self : RedisClient,
  slots : Array[Int],
) -> String {
  let slot_strings = slots.map(fn(slot) { slot.to_string() })
  let args = ["CLUSTER", "DELSLOTS", ..slot_strings]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::cluster_delslotsrange(
  self : RedisClient,
  ranges : Array[(Int, Int)],
) -> String {
  let range_strings = Array::new()
  for range in ranges {
    let (start, end) = range
    range_strings.push(start.to_string())
    range_strings.push(end.to_string())
  }
  let args = ["CLUSTER", "DELSLOTSRANGE", ..range_strings]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::cluster_failover(
  self : RedisClient,
  option? : String,
) -> String {
  let args = match option {
    Some(opt) => ["CLUSTER", "FAILOVER", opt]
    None => ["CLUSTER", "FAILOVER"]
  }
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::cluster_flushslots(self : RedisClient) -> String {
  self.send(["CLUSTER", "FLUSHSLOTS"])
  self.read_response()
}

///|
pub async fn RedisClient::cluster_forget(
  self : RedisClient,
  node_id : String,
) -> String {
  self.send(["CLUSTER", "FORGET", node_id])
  self.read_response()
}

///|
pub async fn RedisClient::cluster_getkeysinslot(
  self : RedisClient,
  slot : Int,
  count : Int,
) -> String {
  self.send(["CLUSTER", "GETKEYSINSLOT", slot.to_string(), count.to_string()])
  self.read_response()
}

///|
pub async fn RedisClient::cluster_info(self : RedisClient) -> String {
  self.send(["CLUSTER", "INFO"])
  self.read_response()
}

///|
pub async fn RedisClient::cluster_keyslot(
  self : RedisClient,
  key : String,
) -> String {
  self.send(["CLUSTER", "KEYSLOT", key])
  self.read_response()
}

///|
pub async fn RedisClient::cluster_links(self : RedisClient) -> String {
  self.send(["CLUSTER", "LINKS"])
  self.read_response()
}

///|
pub async fn RedisClient::cluster_meet(
  self : RedisClient,
  ip : String,
  port : Int,
  cluster_bus_port? : Int,
) -> String {
  let args = match cluster_bus_port {
    Some(bus_port) =>
      ["CLUSTER", "MEET", ip, port.to_string(), bus_port.to_string()]
    None => ["CLUSTER", "MEET", ip, port.to_string()]
  }
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::cluster_myid(self : RedisClient) -> String {
  self.send(["CLUSTER", "MYID"])
  self.read_response()
}

///|
pub async fn RedisClient::cluster_myshardid(self : RedisClient) -> String {
  self.send(["CLUSTER", "MYSHARDID"])
  self.read_response()
}

///|
pub async fn RedisClient::cluster_nodes(self : RedisClient) -> String {
  self.send(["CLUSTER", "NODES"])
  self.read_response()
}

///|
pub async fn RedisClient::cluster_replicas(
  self : RedisClient,
  node_id : String,
) -> String {
  self.send(["CLUSTER", "REPLICAS", node_id])
  self.read_response()
}

///|
pub async fn RedisClient::cluster_replicate(
  self : RedisClient,
  node_id : String,
) -> String {
  self.send(["CLUSTER", "REPLICATE", node_id])
  self.read_response()
}

///|
pub async fn RedisClient::cluster_reset(
  self : RedisClient,
  reset_type? : String,
) -> String {
  let args = match reset_type {
    Some(type_) => ["CLUSTER", "RESET", type_]
    None => ["CLUSTER", "RESET"]
  }
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::cluster_saveconfig(self : RedisClient) -> String {
  self.send(["CLUSTER", "SAVECONFIG"])
  self.read_response()
}

///|
pub async fn RedisClient::cluster_set_config_epoch(
  self : RedisClient,
  config_epoch : Int,
) -> String {
  self.send(["CLUSTER", "SET-CONFIG-EPOCH", config_epoch.to_string()])
  self.read_response()
}

///|
pub async fn RedisClient::cluster_setslot(
  self : RedisClient,
  slot : Int,
  subcommand : String,
  node_id? : String,
) -> String {
  let args = match node_id {
    Some(id) => ["CLUSTER", "SETSLOT", slot.to_string(), subcommand, id]
    None => ["CLUSTER", "SETSLOT", slot.to_string(), subcommand]
  }
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::cluster_shards(self : RedisClient) -> String {
  self.send(["CLUSTER", "SHARDS"])
  self.read_response()
}

///|
pub async fn RedisClient::cluster_slaves(
  self : RedisClient,
  node_id : String,
) -> String {
  self.send(["CLUSTER", "SLAVES", node_id])
  self.read_response()
}

///|
pub async fn RedisClient::cluster_slot_stats(
  self : RedisClient,
  slots : Array[Int],
) -> String {
  let slot_strings = slots.map(fn(slot) { slot.to_string() })
  let args = ["CLUSTER", "SLOTS", "STATS", ..slot_strings]
  self.send(args)
  self.read_response()
}

///|
pub async fn RedisClient::cluster_slots(self : RedisClient) -> String {
  self.send(["CLUSTER", "SLOTS"])
  self.read_response()
}
