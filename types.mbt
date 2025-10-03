// ============ Redis 响应类型系统 ============

///|
/// Redis响应的基本类型
pub enum RedisValue {
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
}

///|
/// Redis命令的结果类型
pub typealias Result[T, String] as RedisResult[T]

///|
/// 常用的具体返回类型
pub typealias RedisResult[String?] as RedisString

///|
pub typealias RedisResult[Int] as RedisInt

///|
pub typealias RedisResult[Bool] as RedisBool

///|
pub typealias RedisResult[Array[String]] as RedisArray

///|
pub typealias RedisResult[Array[(String, String)]] as RedisHash

///|
/// 将RedisValue转换为具体类型
pub fn RedisValue::to_string(self : RedisValue) -> RedisString {
  match self {
    SimpleString(s) => Result::Ok(Some(s))
    BulkString(s) => Result::Ok(s)
    Error(e) => Result::Err(e)
    _ => Result::Err("Type mismatch: expected string")
  }
}

///|
/// 将RedisValue转换为整数
pub fn RedisValue::to_int(self : RedisValue) -> RedisInt {
  match self {
    Integer(i) => Result::Ok(i)
    SimpleString(s) =>
      // 简单的字符串转整数实现
      if s == "0" {
        Result::Ok(0)
      } else if s == "1" {
        Result::Ok(1)
      } else if s == "-1" {
        Result::Ok(-1)
      } else {
        Result::Err("Cannot parse '\{s}' as integer")
      }
    Error(e) => Result::Err(e)
    _ => Result::Err("Type mismatch: expected integer")
  }
}

///|
/// 将RedisValue转换为布尔值
pub fn RedisValue::to_bool(self : RedisValue) -> RedisBool {
  match self {
    Integer(i) => Result::Ok(i != 0)
    SimpleString(s) => Result::Ok(s == "OK")
    Error(e) => Result::Err(e)
    _ => Result::Err("Type mismatch: expected boolean")
  }
}

///|
/// 将RedisValue转换为字符串数组
pub fn RedisValue::to_array(self : RedisValue) -> RedisArray {
  match self {
    Array(arr) => {
      let result = Array::new()
      for item in arr {
        match item.to_string() {
          Result::Ok(Some(s)) => result.push(s)
          Result::Ok(None) => result.push("(nil)")
          Result::Err(_) =>
            return Result::Err("Array contains non-string elements")
        }
      }
      Result::Ok(result)
    }
    Error(e) => Result::Err(e)
    _ => Result::Err("Type mismatch: expected array")
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
      if int_str == "0" {
        Integer(0)
      } else if int_str == "1" {
        Integer(1)
      } else if int_str == "-1" {
        Integer(-1)
      } else {
        Error("Invalid integer: \{int_str}")
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
    if char_code == '\r'.to_int() && i + 1 < len && text[i + 1] == '\n'.to_int() {
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
    if response[content_start] == '\r'.to_int() &&
      response[content_start + 1] == '\n'.to_int() {
      content_start = content_start + 2
      break
    }
    content_start = content_start + 1
  }
  let content = extract_line_content(response, content_start)
  BulkString(Some(content))
}

///|
/// 解析数组（简化版本）
fn parse_array_value(response : String) -> RedisValue {
  let count_str = extract_line_content(response, 1)

  // 检查null数组
  if count_str == "-1" {
    return Array([])
  }

  // 简化实现：返回空数组
  // 完整实现需要递归解析每个元素
  Array([])
}
