///|
/// String命令测试套件

///|
fn string_test_key(name : String) -> String {
  "test:string:\{name}"
}

///|
async test "string_ping" {
  let client = @redis.connect("localhost", port=6379)
  defer client.close()
  let pong = client.ping()
  assert_true(pong is Ok("PONG"))
}

///|
/// 测试SET和GET命令
async test "string_set_get" {
  let client = @redis.connect("localhost", port=6379)
  defer client.close()
  let key = string_test_key("set_get")
  let _ = client.del([key])

  // 测试SET
  let set_result = client.set(key, "hello_world")
  assert_true(set_result is Ok("OK"))

  // 测试GET
  let get_result = client.get(key)
  assert_true(get_result is Ok("hello_world"))

  // 清理
  let _ = client.del([key])
}

///|
/// 测试APPEND命令
async test "string_append" {
  let client = @redis.connect("localhost", port=6379)
  defer client.close()
  let key = string_test_key("append")
  let _ = client.del([key])

  // 设置初始值
  let _ = client.set(key, "hello")

  // 测试APPEND
  let append_result = client.append(key, "_world")
  assert_true(append_result is Ok(11)) // "hello_world"的长度

  // 验证结果
  let get_result = client.get(key)
  assert_true(get_result is Ok("hello_world"))

  // 清理
  let _ = client.del([key])
}

///|
/// 测试INCR和DECR命令
async test "string_incr_decr" {
  let client = @redis.connect("localhost", port=6379)
  defer client.close()
  let key = string_test_key("counter")
  let _ = client.del([key])

  // 设置初始值
  let _ = client.set(key, "10")

  // 测试INCR
  let incr_result = client.incr(key)
  assert_true(incr_result is Ok(11))

  // 测试DECR
  let decr_result = client.decr(key)
  assert_true(decr_result is Ok(10))

  // 清理
  let _ = client.del([key])
}

///|
/// 测试STRLEN命令
async test "string_strlen" {
  let client = @redis.connect("localhost", port=6379)
  defer client.close()
  let key = string_test_key("strlen")
  let _ = client.del([key])

  // 设置测试值
  let _ = client.set(key, "hello")

  // 测试STRLEN
  let strlen_result = client.strlen(key)
  assert_true(strlen_result is Ok(5))

  // 清理
  let _ = client.del([key])
}

///|
/// 测试MSET和MGET命令
async test "string_mset_mget" {
  let client = @redis.connect("localhost", port=6379)
  defer client.close()
  let key1 = string_test_key("mset_mget_1")
  let key2 = string_test_key("mset_mget_2")
  let _ = client.del([key1, key2])

  // 测试MSET
  let mset_result = client.mset(Map([(key1, "value1"), (key2, "value2")]))
  assert_true(mset_result is Ok("OK"))

  // 测试MGET
  let mget_result = client.mget([key1, key2])
  assert_true(mget_result is Ok(["value1", "value2"]))

  // 清理
  let _ = client.del([key1, key2])
}
