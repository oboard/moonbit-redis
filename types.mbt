// ============ Redis 响应类型系统 ============

///|
/// Redis响应的基本类型
pub(all) enum RedisValue {
  // 简单字符串: +OK\r\n
  SimpleString(String)
  // 错误: -ERR message\r\n  
  Error(String)
  // 整数: :1000\r\n
  Integer(Int)
  // 批量字符串: $6\r\nfoobar\r\n 或 $-1\r\n (null)
  BulkString(String?)
  // 数组: *count\r\n<element1><element2>...
  Array(Array[RedisValue])
} derive(Debug, Hash, Eq)

///|
pub extend RedisValue with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RedisValue with @moonbitlang/core/builtin.Hash::{hash, hash_combine}

///|
pub extend RedisValue with @moonbitlang/core/builtin.Eq::{equal, not_equal}

///|
pub extend RedisValue with Show::{output}

///|
pub impl Show for RedisValue with fn output(self, logger : &Logger) -> Unit {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for RedisValue with fn to_string(self) -> String {
  @debug.to_string(self)
}

///|
/// Redis命令的结果类型
pub type RedisResult[T] = Result[T, String]

///|
/// 常用的具体返回类型
pub type RedisString = RedisResult[String]

///|
pub type RedisJson = RedisResult[Json]

///|
pub type RedisBulkString = RedisResult[String?]

///|
pub type RedisInt = RedisResult[Int]

///|
pub type RedisBool = RedisResult[Bool]

///|
pub type RedisArray = RedisResult[Array[String]]

///|
pub type RedisHash = RedisResult[Map[String, String]]

///|
pub type RedisStreamResult = RedisResult[RedisStream]

///|
pub type RedisStreamMessageArray = RedisResult[Array[RedisStreamMessage]]

///|
pub(all) struct RedisStreamMessage {
  id : String
  fields : Array[String]
} derive(Debug)

///|
pub extend RedisStreamMessage with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RedisStreamMessage with Show::{to_string, output}

///|
pub impl Show for RedisStreamMessage with fn output(
  self : RedisStreamMessage,
  logger : &Logger,
) -> Unit {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for RedisStreamMessage with fn to_string(
  self : RedisStreamMessage,
) -> String {
  @debug.to_string(self)
}

///|
pub(all) struct RedisStream {
  name : String
  messages : Array[RedisStreamMessage]
} derive(Debug)

///|
pub extend RedisStream with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RedisStream with Show::{to_string, output}

///|
pub impl Show for RedisStream with fn output(
  self : RedisStream,
  logger : &Logger,
) -> Unit {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for RedisStream with fn to_string(self : RedisStream) -> String {
  @debug.to_string(self)
}

///|
pub fn RedisValue::to_stream(self : RedisValue) -> RedisStreamResult {
  match self {
    Array(streams) =>
      // Redis Stream 响应格式: [[stream_name, [[id, [field, value, ...]], ...]]]
      match streams[0] {
        Array(stream_data) =>
          if stream_data.length() >= 2 {
            let stream_name = match stream_data[0].to_string() {
              Ok(name) => name
              Err(_) => ""
            }
            let messages = match stream_data[1] {
              Array(msg_array) => parse_stream_messages(msg_array)
              _ => []
            }
            Ok({ name: stream_name, messages, })
          } else {
            Err("Invalid stream data: expected array with at least 2 elements")
          }
        _ => Err("Invalid stream data: expected array")
      }
    _ => Err("Invalid stream data: expected array")
  }
}

///|
/// 解析 Stream 消息数组
fn parse_stream_messages(
  msg_array : Array[RedisValue],
) -> Array[RedisStreamMessage] {
  let messages = []
  for msg in msg_array {
    match msg {
      Array(msg_data) =>
        if msg_data.length() >= 2 {
          let id = match msg_data[0].to_string() {
            Ok(id_str) => id_str
            Err(_) => ""
          }
          let fields = match msg_data[1] {
            Array(field_array) => {
              let field_strings = []
              for field in field_array {
                match field.to_string() {
                  Ok(field_str) => field_strings.push(field_str)
                  Err(_) => ()
                }
              }
              field_strings
            }
            _ => []
          }
          messages.push({ id, fields, })
        }
      _ => ()
    }
  }
  messages
}

///|
/// 将RedisValue转换为Stream消息数组（用于XRANGE等命令）
pub fn RedisValue::to_stream_message_array(
  self : RedisValue,
) -> RedisStreamMessageArray {
  match self {
    Array(msg_array) => Ok(parse_stream_messages(msg_array))
    _ => Err("Invalid stream message array")
  }
}

///|
/// 将RedisValue转换为具体类型
pub fn RedisValue::to_bulk_string(self : RedisValue) -> RedisBulkString {
  match self {
    BulkString(Some(s)) => Ok(Some(s))
    Error(e) => Err(e)
    _ => Err("Type mismatch: expected string")
  }
}

///|
/// 将RedisValue转换为具体类型
pub fn RedisValue::to_string(self : RedisValue) -> RedisString {
  match self {
    SimpleString(s) => Ok(s)
    BulkString(Some(s)) => Ok(s)
    Error(e) => Err(e)
    _ => Err("Type mismatch: expected string")
  }
}

///|
/// 将RedisValue转换为JSON
pub fn RedisValue::to_json(self : RedisValue) -> RedisJson {
  self.to_string().map(s => @json.parse(s) catch { _ => Json::null() })
}

///|
/// 将RedisValue转换为整数
pub fn RedisValue::to_int(self : RedisValue) -> RedisInt {
  match self {
    Integer(i) => Ok(i)
    Error(e) => Err(e)
    _ => Err("Type mismatch: expected integer")
  }
}

///|
/// 将RedisValue转换为布尔值
pub fn RedisValue::to_bool(self : RedisValue) -> RedisBool {
  match self {
    Integer(i) => Ok(i != 0)
    SimpleString(s) => Ok(s == "OK")
    Error(e) => Err(e)
    _ => Err("Type mismatch: expected boolean")
  }
}

///|
/// 将RedisValue转换为数组
pub fn RedisValue::to_array(self : RedisValue) -> RedisArray {
  match self {
    Array(arr) => Ok(arr.map(item => item.to_array_item_string()))
    Error(e) => Err(e)
    _ => Err("Type mismatch: expected array")
  }
}

///|
fn RedisValue::to_array_item_string(self : RedisValue) -> String {
  match self {
    SimpleString(s) | BulkString(Some(s)) => s
    BulkString(None) => "null"
    Integer(i) => i.to_string()
    Array(arr) => "[\{arr.map(item => item.to_array_item_string()).join(", ")}]"
    Error(e) => "ERR \{e}"
  }
}
