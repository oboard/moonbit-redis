// ============ 流命令 ============

///|
/// 添加条目到流
pub async fn RedisClient::xadd(
  self : RedisClient,
  key : String,
  id : String,
  field_values : Map[String, String],
) -> RedisString {
  let values = field_values
    .map(fn(k, v) -> Array[String] { [k, v] })
    .values()
    .to_array()
    .flatten()
  let args = ["XADD", key, id, ..values]
  self.send(args).to_string()
}

///|
/// 读取流条目
pub async fn RedisClient::xread(
  self : RedisClient,
  count? : Int,
  block? : Int,
  streams : Array[(String, String)],
) -> RedisStreamResult {
  let args = ["XREAD"]
  if count is Some(c) {
    args.append(["COUNT", c.to_string()])
  }
  if block is Some(b) {
    args.append(["BLOCK", b.to_string()])
  }
  let (keys, ids) = streams.unzip()
  args.append(["STREAMS", ..keys, ..ids])
  self.send(args).to_stream()
}

///|
/// 范围查询流条目
pub async fn RedisClient::xrange(
  self : RedisClient,
  key : String,
  start~ : String,
  end~ : String,
  count? : Int,
) -> RedisStreamMessageArray {
  let args = ["XRANGE", key, start, end]
  if count is Some(c) {
    args.append(["COUNT", c.to_string()])
  }
  self.send(args).to_stream_message_array()
}

///|
/// 反向范围查询流条目
pub async fn RedisClient::xrevrange(
  self : RedisClient,
  key : String,
  end~ : String,
  start~ : String,
  count? : Int,
) -> RedisStreamMessageArray {
  let args = ["XREVRANGE", key, end, start]
  if count is Some(c) {
    args.append(["COUNT", c.to_string()])
  }
  self.send(args).to_stream_message_array()
}

///|
/// 获取流长度
pub async fn RedisClient::xlen(self : RedisClient, key : String) -> RedisInt {
  self.send(["XLEN", key]).to_int()
}

///|
/// 删除流条目
pub async fn RedisClient::xdel(
  self : RedisClient,
  key : String,
  ids : Array[String],
) -> RedisInt {
  let args = ["XDEL", key, ..ids]
  self.send(args).to_int()
}

///|
pub(all) enum XTrimStrategy {
  MaxLen
  MinID
}

///|
impl Show for XTrimStrategy with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
impl Show for XTrimStrategy with to_string(self) {
  match self {
    MaxLen => "MAXLEN"
    MinID => "MINID"
  }
}

///|
/// 修剪流
pub async fn RedisClient::xtrim(
  self : RedisClient,
  key : String,
  strategy~ : XTrimStrategy,
  threshold~ : Int64,
  approximate? : Bool = false,
  limit? : Int,
  keepref? : Bool = false,
  delref? : Bool = false,
  acked? : Bool = false,
) -> RedisInt {
  let args = ["XTRIM", key, strategy.to_string()]
  if approximate {
    args.push("~")
  }
  args.push(threshold.to_string())
  if limit is Some(l) {
    args.append(["LIMIT", l.to_string()])
  }
  if keepref {
    args.push("KEEPREF")
  }
  if delref {
    args.push("DELREF")
  }
  if acked {
    args.push("ACKED")
  }
  self.send(args).to_int()
}

///|
/// 创建消费者组
pub async fn RedisClient::xgroup_create(
  self : RedisClient,
  key : String,
  group : String,
  id : String,
  mkstream : Bool,
) -> RedisString {
  let args = ["XGROUP", "CREATE", key, group, id]
  if mkstream {
    args.push("MKSTREAM")
  }
  self.send(args).to_string()
}

///|
/// 销毁消费者组
pub async fn RedisClient::xgroup_destroy(
  self : RedisClient,
  key : String,
  group : String,
) -> RedisInt {
  self.send(["XGROUP", "DESTROY", key, group]).to_int()
}

///|
/// 创建消费者
pub async fn RedisClient::xgroup_createconsumer(
  self : RedisClient,
  key : String,
  group : String,
  consumer : String,
) -> RedisInt {
  self.send(["XGROUP", "CREATECONSUMER", key, group, consumer]).to_int()
}

///|
/// 删除消费者
pub async fn RedisClient::xgroup_delconsumer(
  self : RedisClient,
  key : String,
  group : String,
  consumer : String,
) -> RedisInt {
  self.send(["XGROUP", "DELCONSUMER", key, group, consumer]).to_int()
}

///|
/// 设置消费者组ID
pub async fn RedisClient::xgroup_setid(
  self : RedisClient,
  key : String,
  group : String,
  id : String,
) -> RedisString {
  self.send(["XGROUP", "SETID", key, group, id]).to_string()
}

///|
/// 消费者组读取
pub async fn RedisClient::xreadgroup(
  self : RedisClient,
  group : String,
  consumer : String,
  count? : Int,
  block? : Int,
  noack? : Bool = false,
  streams : Array[(String, String)],
) -> RedisResult[RedisStream] {
  let args = ["XREADGROUP", "GROUP", group, consumer]
  if count is Some(c) {
    args.append(["COUNT", c.to_string()])
  }
  if block is Some(b) {
    args.append(["BLOCK", b.to_string()])
  }
  if noack {
    args.push("NOACK")
  }
  let (keys, ids) = streams.unzip()
  args.append(["STREAMS", ..keys, ..ids])
  self.send(args).to_stream()
}

///|
/// 确认消息
pub async fn RedisClient::xack(
  self : RedisClient,
  key : String,
  group : String,
  ids : Array[String],
) -> RedisInt {
  let args = ["XACK", key, group, ..ids]
  self.send(args).to_int()
}

///|
/// 查看待处理消息
pub async fn RedisClient::xpending(
  self : RedisClient,
  key : String,
  group : String,
) -> RedisArray {
  self.send(["XPENDING", key, group]).to_array()
}

///|
/// 查看待处理消息详情
pub async fn RedisClient::xpending_range(
  self : RedisClient,
  key : String,
  group : String,
  start~ : String,
  end~ : String,
  count~ : Int,
  consumer? : String,
) -> RedisArray {
  let args = ["XPENDING", key, group, start, end, count.to_string()]
  if consumer is Some(c) {
    args.push(c)
  }
  self.send(args).to_array()
}

///|
/// 声明消息
pub async fn RedisClient::xclaim(
  self : RedisClient,
  key : String,
  group : String,
  consumer : String,
  min_idle_time : Int,
  ids : Array[String],
) -> RedisArray {
  let args = ["XCLAIM", key, group, consumer, min_idle_time.to_string(), ..ids]
  self.send(args).to_array()
}

///|
/// 自动声明消息
pub async fn RedisClient::xautoclaim(
  self : RedisClient,
  key : String,
  group : String,
  consumer : String,
  min_idle_time : Int,
  start~ : String,
  count? : Int,
) -> RedisArray {
  let args = [
    "XAUTOCLAIM",
    key,
    group,
    consumer,
    min_idle_time.to_string(),
    start,
  ]
  if count is Some(c) {
    args.append(["COUNT", c.to_string()])
  }
  self.send(args).to_array()
}

///|
/// 获取流信息
pub async fn RedisClient::xinfo_stream(
  self : RedisClient,
  key : String,
) -> RedisArray {
  self.send(["XINFO", "STREAM", key]).to_array()
}

///|
/// 获取消费者组信息
pub async fn RedisClient::xinfo_groups(
  self : RedisClient,
  key : String,
) -> RedisArray {
  self.send(["XINFO", "GROUPS", key]).to_array()
}

///|
/// 获取消费者信息
pub async fn RedisClient::xinfo_consumers(
  self : RedisClient,
  key : String,
  group : String,
) -> RedisArray {
  self.send(["XINFO", "CONSUMERS", key, group]).to_array()
}
