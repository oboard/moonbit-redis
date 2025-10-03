// ============ JSON 命令 ============

///|
/// JSON.SET - 设置JSON值
pub async fn RedisClient::json_set(
  self : RedisClient,
  key : String,
  path : String,
  value : String,
) -> RedisString {
  self.send(["JSON.SET", key, path, value]).to_string()
}

///|
/// JSON.GET - 获取JSON值
pub async fn RedisClient::json_get(
  self : RedisClient,
  key : String,
  path : String,
) -> RedisString {
  self.send(["JSON.GET", key, path]).to_string()
}

///|
/// JSON.DEL - 删除JSON路径
pub async fn RedisClient::json_del(
  self : RedisClient,
  key : String,
  path : String,
) -> RedisInt {
  self.send(["JSON.DEL", key, path]).to_int()
}

///|
/// JSON.TYPE - 获取JSON值类型
pub async fn RedisClient::json_type(
  self : RedisClient,
  key : String,
  path : String,
) -> RedisString {
  self.send(["JSON.TYPE", key, path]).to_string()
}

///|
/// JSON.STRLEN - 获取JSON字符串长度
pub async fn RedisClient::json_strlen(
  self : RedisClient,
  key : String,
  path : String,
) -> RedisInt {
  self.send(["JSON.STRLEN", key, path]).to_int()
}

///|
/// JSON.ARRLEN - 获取JSON数组长度
pub async fn RedisClient::json_arrlen(
  self : RedisClient,
  key : String,
  path : String,
) -> RedisInt {
  self.send(["JSON.ARRLEN", key, path]).to_int()
}

///|
/// JSON.ARRAPPEND - 向JSON数组追加元素
pub async fn RedisClient::json_arrappend(
  self : RedisClient,
  key : String,
  path : String,
  values : Array[String],
) -> RedisInt {
  let args = ["JSON.ARRAPPEND", key, path, ..values]
  self.send(args).to_int()
}

///|
/// JSON.ARRINSERT - 在JSON数组指定位置插入元素
pub async fn RedisClient::json_arrinsert(
  self : RedisClient,
  key : String,
  path : String,
  index : Int,
  values : Array[String],
) -> RedisInt {
  let args = ["JSON.ARRINSERT", key, path, index.to_string(), ..values]
  self.send(args).to_int()
}

///|
/// JSON.ARRPOP - 从JSON数组弹出元素
pub async fn RedisClient::json_arrpop(
  self : RedisClient,
  key : String,
  path : String,
  index : Int,
) -> RedisString {
  self.send(["JSON.ARRPOP", key, path, index.to_string()]).to_string()
}

///|
/// JSON.ARRTRIM - 修剪JSON数组
pub async fn RedisClient::json_arrtrim(
  self : RedisClient,
  key : String,
  path : String,
  start : Int,
  stop : Int,
) -> RedisInt {
  self
  .send(["JSON.ARRTRIM", key, path, start.to_string(), stop.to_string()])
  .to_int()
}

///|
/// JSON.OBJKEYS - 获取JSON对象的键
pub async fn RedisClient::json_objkeys(
  self : RedisClient,
  key : String,
  path : String,
) -> RedisArray {
  self.send(["JSON.OBJKEYS", key, path]).to_array()
}

///|
/// JSON.OBJLEN - 获取JSON对象的键数量
pub async fn RedisClient::json_objlen(
  self : RedisClient,
  key : String,
  path : String,
) -> RedisInt {
  self.send(["JSON.OBJLEN", key, path]).to_int()
}

///|
/// JSON.NUMINCRBY - 对JSON数值进行增量操作
pub async fn RedisClient::json_numincrby(
  self : RedisClient,
  key : String,
  path : String,
  value : String,
) -> RedisString {
  self.send(["JSON.NUMINCRBY", key, path, value]).to_string()
}

///|
/// JSON.NUMMULTBY - 对JSON数值进行乘法操作
pub async fn RedisClient::json_nummultby(
  self : RedisClient,
  key : String,
  path : String,
  value : String,
) -> RedisString {
  self.send(["JSON.NUMMULTBY", key, path, value]).to_string()
}

///|
/// JSON.STRAPPEND - 向JSON字符串追加内容
pub async fn RedisClient::json_strappend(
  self : RedisClient,
  key : String,
  path : String,
  value : String,
) -> RedisInt {
  self.send(["JSON.STRAPPEND", key, path, value]).to_int()
}

///|
/// JSON.TOGGLE - 切换JSON布尔值
pub async fn RedisClient::json_toggle(
  self : RedisClient,
  key : String,
  path : String,
) -> RedisInt {
  self.send(["JSON.TOGGLE", key, path]).to_int()
}

///|
/// JSON.CLEAR - 清空JSON值
pub async fn RedisClient::json_clear(
  self : RedisClient,
  key : String,
  path : String,
) -> RedisInt {
  self.send(["JSON.CLEAR", key, path]).to_int()
}

///|
/// JSON.FORGET - 删除JSON路径（JSON.DEL的别名）
pub async fn RedisClient::json_forget(
  self : RedisClient,
  key : String,
  path : String,
) -> RedisInt {
  self.send(["JSON.FORGET", key, path]).to_int()
}

///|
/// JSON.RESP - 以RESP格式返回JSON值
pub async fn RedisClient::json_resp(
  self : RedisClient,
  key : String,
  path : String,
) -> RedisArray {
  self.send(["JSON.RESP", key, path]).to_array()
}

///|
/// JSON.DEBUG - JSON调试命令
pub async fn RedisClient::json_debug(
  self : RedisClient,
  subcommand : String,
  key : String,
  path : String,
) -> RedisString {
  self.send(["JSON.DEBUG", subcommand, key, path]).to_string()
}
