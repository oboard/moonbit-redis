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

///|
/// 解析Redis协议响应
pub fn parse_redis_response(response : String) -> RedisValue {
  if response.length() == 0 {
    return Error("Empty response")
  }
  let first_char = response[0]
  match first_char {
    '+' => SimpleString(extract_line_content(response, 1))
    '-' => Error(extract_line_content(response, 1))
    ':' => {
      let int_str = extract_line_content(response, 1)
      // 简单的字符串转整数实现
      try @string.parse_int(int_str) catch {
        _ => Error("Invalid integer: \{int_str}")
      } noraise {
        i => Integer(i)
      }
    }
    '$' => parse_bulk_string_value(response)
    '*' => parse_array_value(response)
    _ => Error("Unknown response type")
  }
}

///|
/// 提取行内容直到\r\n
fn extract_line_content(text : String, start : Int) -> String {
  let mut i = start
  let len = text.length()
  let mut result = ""
  while i < len {
    let char_code = text[i]
    if char_code == '\r'.to_int().to_uint16() &&
      i + 1 < len &&
      text[i + 1] == '\n'.to_int().to_uint16() {
      break
    }
    result = result + char_code.unsafe_to_char().to_string()
    i = i + 1
  }
  result
}

///|
/// 解析批量字符串
fn parse_bulk_string_value(response : String) -> RedisValue {
  let length_str = extract_line_content(response, 1)

  // 检查null批量字符串
  if length_str == "-1" {
    return BulkString(None)
  }

  // 找到内容开始位置
  let mut content_start = 1
  while content_start < response.length() - 1 {
    if response[content_start] == '\r'.to_int().to_uint16() &&
      response[content_start + 1] == '\n'.to_int().to_uint16() {
      content_start = content_start + 2
      break
    }
    content_start = content_start + 1
  }
  let content = extract_line_content(response, content_start)
  BulkString(Some(content))
}

///|
/// 解析数组
fn parse_array_value(response : String) -> RedisValue {
  let count_str = extract_line_content(response, 1)

  // 检查null数组
  if count_str == "-1" {
    return Array([])
  }

  // 解析数组元素个数
  let count = try @string.parse_int(count_str) catch {
    _ => return Error("Invalid array count: \{count_str}")
  } noraise {
    n => n
  }
  if count == 0 {
    return Array([])
  }
  // 找到第一个元素的开始位置（跳过 *count\r\n）
  let mut pos = 1
  while pos < response.length() - 1 {
    if response[pos] == '\r'.to_int().to_uint16() &&
      response[pos + 1] == '\n'.to_int().to_uint16() {
      pos = pos + 2
      break
    }
    pos = pos + 1
  }
  let elements = []
  let mut current_pos = pos

  // 解析每个元素
  for i = 0; i < count; i = i + 1 {
    if current_pos >= response.length() {
      break
    }

    // 提取当前元素的完整RESP数据
    let element_data = extract_element_data(response, current_pos)
    match element_data {
      Ok((element_str, next_pos)) => {
        // 递归调用parse_redis_response解析元素
        let element_value = parse_redis_response(element_str)
        elements.push(element_value)
        current_pos = next_pos
      }
      Err(err) => return Error("Failed to parse array element: \{err}")
    }
  }
  Array(elements)
}

///|
/// 从响应中提取单个元素的完整数据
fn extract_element_data(
  response : String,
  start_pos : Int,
) -> Result[(String, Int), String] {
  if start_pos >= response.length() {
    return Err("Position out of bounds")
  }
  let element_type = response[start_pos]
  match element_type {
    '$' => {
      // 批量字符串：$length\r\ncontent\r\n
      let length_str = extract_line_content(response, start_pos + 1)
      if length_str == "-1" {
        // null字符串：$-1\r\n
        let end_pos = find_line_end(response, start_pos) + 2
        let element_str = response[start_pos:end_pos].to_owned()
        Ok((element_str, end_pos))
      } else {
        let length = try @string.parse_int(length_str) catch {
          _ => return Err("Invalid bulk string length")
        } noraise {
          n => n
        }
        // 计算整个批量字符串的结束位置
        let length_line_end = find_line_end(response, start_pos) + 2
        let content_end = length_line_end + length
        let element_end = content_end + 2 // 加上最后的\r\n
        let element_str = response[start_pos:element_end].to_owned()
        Ok((element_str, element_end))
      }
    }
    '+' | '-' | ':' => {
      // 简单字符串、错误、整数：都是单行格式
      let line_end = find_line_end(response, start_pos) + 2
      let element_str = response[start_pos:line_end].to_owned()
      Ok((element_str, line_end))
    }
    '*' =>
      // 嵌套数组：需要递归计算长度
      extract_array_data(response, start_pos)
    _ => Err("Unknown element type")
  }
}

///|
/// 提取数组数据（支持嵌套）
fn extract_array_data(
  response : String,
  start_pos : Int,
) -> Result[(String, Int), String] {
  let count_str = extract_line_content(response, start_pos + 1)
  if count_str == "-1" {
    // null数组：*-1\r\n
    let end_pos = find_line_end(response, start_pos) + 2
    return Ok((response[start_pos:end_pos].to_owned(), end_pos))
  }
  let count = try @string.parse_int(count_str) catch {
    _ => return Err("Invalid array count")
  } noraise {
    n => n
  }
  if count == 0 {
    // 空数组：*0\r\n
    let end_pos = find_line_end(response, start_pos) + 2
    return Ok((response[start_pos:end_pos].to_owned(), end_pos))
  }

  // 找到数组内容开始位置
  let mut current_pos = find_line_end(response, start_pos) + 2

  // 递归解析每个子元素来计算总长度
  for i = 0; i < count; i = i + 1 {
    match extract_element_data(response, current_pos) {
      Ok((_, next_pos)) => current_pos = next_pos
      Err(err) => return Err("Failed to parse nested element: \{err}")
    }
  }
  let element_str = response[start_pos:current_pos].to_owned()
  Ok((element_str, current_pos))
}

///|
/// 找到行结束位置（\r\n之前的位置）
fn find_line_end(text : String, start : Int) -> Int {
  let mut i = start
  while i < text.length() - 1 {
    if text[i] == '\r'.to_int().to_uint16() &&
      text[i + 1] == '\n'.to_int().to_uint16() {
      return i
    }
    i = i + 1
  }
  text.length()
}
