// ============ 发布订阅命令 ============

///|
/// 发布消息到指定频道
/// 返回接收到消息的订阅者数量
pub async fn RedisClient::publish(
  self : RedisClient,
  channel : String,
  message : String,
) -> RedisInt {
  self.send(["PUBLISH", channel, message]).to_int()
}

///|
/// 订阅一个或多个频道
/// 返回订阅确认信息数组
pub async fn RedisClient::subscribe(
  self : RedisClient,
  channels : Array[String],
) -> RedisArray {
  let args = ["SUBSCRIBE", ..channels]
  self.send(args).to_array()
}

///|
/// 取消订阅频道
/// 如果不指定频道，则取消所有订阅
pub async fn RedisClient::unsubscribe(
  self : RedisClient,
  channels? : Array[String],
) -> RedisArray {
  let args = match channels {
    Some(chs) => ["UNSUBSCRIBE", ..chs]
    None => ["UNSUBSCRIBE"]
  }
  self.send(args).to_array()
}

///|
/// 订阅一个或多个模式
/// 返回模式订阅确认信息数组
pub async fn RedisClient::psubscribe(
  self : RedisClient,
  patterns : Array[String],
) -> RedisArray {
  let args = ["PSUBSCRIBE", ..patterns]
  self.send(args).to_array()
}

///|
/// 取消订阅模式
/// 如果不指定模式，则取消所有模式订阅
pub async fn RedisClient::punsubscribe(
  self : RedisClient,
  patterns? : Array[String],
) -> RedisArray {
  let args = match patterns {
    Some(pts) => ["PUNSUBSCRIBE", ..pts]
    None => ["PUNSUBSCRIBE"]
  }
  self.send(args).to_array()
}

///|
/// 查看订阅与发布系统状态
/// PUBSUB CHANNELS [pattern] - 列出当前活跃频道
pub async fn RedisClient::pubsub_channels(
  self : RedisClient,
  pattern? : String,
) -> RedisArray {
  let args = match pattern {
    Some(p) => ["PUBSUB", "CHANNELS", p]
    None => ["PUBSUB", "CHANNELS"]
  }
  self.send(args).to_array()
}

///|
/// 查看订阅与发布系统状态
/// PUBSUB NUMSUB [channel [channel ...]] - 返回频道订阅者数量
pub async fn RedisClient::pubsub_numsub(
  self : RedisClient,
  channels? : Array[String],
) -> RedisArray {
  let args = match channels {
    Some(chs) => ["PUBSUB", "NUMSUB", ..chs]
    None => ["PUBSUB", "NUMSUB"]
  }
  self.send(args).to_array()
}

///|
/// 查看订阅与发布系统状态
/// PUBSUB NUMPAT - 返回模式订阅数量
pub async fn RedisClient::pubsub_numpat(self : RedisClient) -> RedisInt {
  self.send(["PUBSUB", "NUMPAT"]).to_int()
}

///|
/// 查看订阅与发布系统状态
/// PUBSUB SHARDCHANNELS [pattern] - 列出分片频道
pub async fn RedisClient::pubsub_shardchannels(
  self : RedisClient,
  pattern? : String,
) -> RedisArray {
  let args = match pattern {
    Some(p) => ["PUBSUB", "SHARDCHANNELS", p]
    None => ["PUBSUB", "SHARDCHANNELS"]
  }
  self.send(args).to_array()
}

///|
/// 查看订阅与发布系统状态
/// PUBSUB SHARDNUMSUB [channel [channel ...]] - 返回分片频道订阅者数量
pub async fn RedisClient::pubsub_shardnumsub(
  self : RedisClient,
  channels? : Array[String],
) -> RedisArray {
  let args = match channels {
    Some(chs) => ["PUBSUB", "SHARDNUMSUB", ..chs]
    None => ["PUBSUB", "SHARDNUMSUB"]
  }
  self.send(args).to_array()
}

///|
/// 发布消息到分片频道
/// 返回接收到消息的订阅者数量
pub async fn RedisClient::spublish(
  self : RedisClient,
  channel : String,
  message : String,
) -> RedisInt {
  self.send(["SPUBLISH", channel, message]).to_int()
}

///|
/// 订阅分片频道
/// 返回订阅确认信息数组
pub async fn RedisClient::ssubscribe(
  self : RedisClient,
  channels : Array[String],
) -> RedisArray {
  let args = ["SSUBSCRIBE", ..channels]
  self.send(args).to_array()
}

///|
/// 取消订阅分片频道
/// 如果不指定频道，则取消所有分片频道订阅
pub async fn RedisClient::sunsubscribe(
  self : RedisClient,
  channels? : Array[String],
) -> RedisArray {
  let args = match channels {
    Some(chs) => ["SUNSUBSCRIBE", ..chs]
    None => ["SUNSUBSCRIBE"]
  }
  self.send(args).to_array()
}
