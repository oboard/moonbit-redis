// ============ 集群命令 ============

///|
pub async fn RedisClient::cluster_addslots(
  self : RedisClient,
  slots : Array[Int],
) -> RedisString {
  let slot_strings = slots.map(fn(slot) { slot.to_string() })
  let args = ["CLUSTER", "ADDSLOTS", ..slot_strings]
  self.send(args).to_string()
}

///|
pub async fn RedisClient::cluster_addslotsrange(
  self : RedisClient,
  ranges : Array[(Int, Int)],
) -> RedisString {
  let range_strings = Array::new()
  for range in ranges {
    let (start, end) = range
    range_strings.push(start.to_string())
    range_strings.push(end.to_string())
  }
  let args = ["CLUSTER", "ADDSLOTSRANGE", ..range_strings]
  self.send(args).to_string()
}

///|
pub async fn RedisClient::cluster_bumpepoch(self : RedisClient) -> RedisString {
  self.send(["CLUSTER", "BUMPEPOCH"]).to_string()
}

///|
pub async fn RedisClient::cluster_count_failure_reports(
  self : RedisClient,
  node_id : String,
) -> RedisInt {
  self.send(["CLUSTER", "COUNT-FAILURE-REPORTS", node_id]).to_int()
}

///|
pub async fn RedisClient::cluster_countkeysinslot(
  self : RedisClient,
  slot : Int,
) -> RedisInt {
  self.send(["CLUSTER", "COUNTKEYSINSLOT", slot.to_string()]).to_int()
}

///|
pub async fn RedisClient::cluster_delslots(
  self : RedisClient,
  slots : Array[Int],
) -> RedisString {
  let slot_strings = slots.map(fn(slot) { slot.to_string() })
  let args = ["CLUSTER", "DELSLOTS", ..slot_strings]
  self.send(args).to_string()
}

///|
pub async fn RedisClient::cluster_delslotsrange(
  self : RedisClient,
  ranges : Array[(Int, Int)],
) -> RedisString {
  let range_strings = Array::new()
  for range in ranges {
    let (start, end) = range
    range_strings.push(start.to_string())
    range_strings.push(end.to_string())
  }
  let args = ["CLUSTER", "DELSLOTSRANGE", ..range_strings]
  self.send(args).to_string()
}

///|
pub async fn RedisClient::cluster_failover(
  self : RedisClient,
  option? : String,
) -> RedisString {
  let args = match option {
    Some(opt) => ["CLUSTER", "FAILOVER", opt]
    None => ["CLUSTER", "FAILOVER"]
  }
  self.send(args).to_string()
}

///|
pub async fn RedisClient::cluster_flushslots(self : RedisClient) -> RedisString {
  self.send(["CLUSTER", "FLUSHSLOTS"]).to_string()
}

///|
pub async fn RedisClient::cluster_forget(
  self : RedisClient,
  node_id : String,
) -> RedisString {
  self.send(["CLUSTER", "FORGET", node_id]).to_string()
}

///|
pub async fn RedisClient::cluster_getkeysinslot(
  self : RedisClient,
  slot : Int,
  count : Int,
) -> RedisArray {
  self
  .send(["CLUSTER", "GETKEYSINSLOT", slot.to_string(), count.to_string()])
  .to_array()
}

///|
pub async fn RedisClient::cluster_info(self : RedisClient) -> RedisString {
  self.send(["CLUSTER", "INFO"]).to_string()
}

///|
pub async fn RedisClient::cluster_keyslot(
  self : RedisClient,
  key : String,
) -> RedisInt {
  self.send(["CLUSTER", "KEYSLOT", key]).to_int()
}

///|
pub async fn RedisClient::cluster_links(self : RedisClient) -> RedisArray {
  self.send(["CLUSTER", "LINKS"]).to_array()
}

///|
pub async fn RedisClient::cluster_meet(
  self : RedisClient,
  ip : String,
  port : Int,
  cluster_bus_port? : Int,
) -> RedisString {
  let args = match cluster_bus_port {
    Some(bus_port) =>
      ["CLUSTER", "MEET", ip, port.to_string(), bus_port.to_string()]
    None => ["CLUSTER", "MEET", ip, port.to_string()]
  }
  self.send(args).to_string()
}

///|
pub async fn RedisClient::cluster_myid(self : RedisClient) -> RedisString {
  self.send(["CLUSTER", "MYID"]).to_string()
}

///|
pub async fn RedisClient::cluster_myshardid(self : RedisClient) -> RedisString {
  self.send(["CLUSTER", "MYSHARDID"]).to_string()
}

///|
pub async fn RedisClient::cluster_nodes(self : RedisClient) -> RedisString {
  self.send(["CLUSTER", "NODES"]).to_string()
}

///|
pub async fn RedisClient::cluster_replicas(
  self : RedisClient,
  node_id : String,
) -> RedisArray {
  self.send(["CLUSTER", "REPLICAS", node_id]).to_array()
}

///|
pub async fn RedisClient::cluster_replicate(
  self : RedisClient,
  node_id : String,
) -> RedisString {
  self.send(["CLUSTER", "REPLICATE", node_id]).to_string()
}

///|
pub async fn RedisClient::cluster_reset(
  self : RedisClient,
  reset_type? : String,
) -> RedisString {
  let args = match reset_type {
    Some(type_) => ["CLUSTER", "RESET", type_]
    None => ["CLUSTER", "RESET"]
  }
  self.send(args).to_string()
}

///|
pub async fn RedisClient::cluster_saveconfig(self : RedisClient) -> RedisString {
  self.send(["CLUSTER", "SAVECONFIG"]).to_string()
}

///|
pub async fn RedisClient::cluster_set_config_epoch(
  self : RedisClient,
  config_epoch : Int,
) -> RedisString {
  self
  .send(["CLUSTER", "SET-CONFIG-EPOCH", config_epoch.to_string()])
  .to_string()
}

///|
pub async fn RedisClient::cluster_setslot(
  self : RedisClient,
  slot : Int,
  subcommand : String,
  node_id? : String,
) -> RedisString {
  let args = match node_id {
    Some(id) => ["CLUSTER", "SETSLOT", slot.to_string(), subcommand, id]
    None => ["CLUSTER", "SETSLOT", slot.to_string(), subcommand]
  }
  self.send(args).to_string()
}

///|
pub async fn RedisClient::cluster_shards(self : RedisClient) -> RedisArray {
  self.send(["CLUSTER", "SHARDS"]).to_array()
}

///|
pub async fn RedisClient::cluster_slaves(
  self : RedisClient,
  node_id : String,
) -> RedisArray {
  self.send(["CLUSTER", "SLAVES", node_id]).to_array()
}

///|
pub async fn RedisClient::cluster_slot_stats(
  self : RedisClient,
  slots : Array[Int],
) -> RedisArray {
  let slot_strings = slots.map(fn(slot) { slot.to_string() })
  let args = ["CLUSTER", "SLOTS", "STATS", ..slot_strings]
  self.send(args).to_array()
}

///|
pub async fn RedisClient::cluster_slots(self : RedisClient) -> RedisArray {
  self.send(["CLUSTER", "SLOTS"]).to_array()
}
