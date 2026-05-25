///| Hash命令测试套件

///|
fn hash_test_key(name : String) -> String {
  "test:hash:\{name}"
}

///|
/// 测试HSET和HGET命令
async test "hash_hset_hget" {
  let client = connect("localhost", 6379)
  defer client.close()
  let key = hash_test_key("hset_hget")
  let _ = client.del([key])

  // 测试HSET
  let hset_result = client.hset(key, "field1", "value1")
  assert_true(hset_result is Ok(1))

  // 测试HGET
  let hget_result = client.hget(key, "field1")
  assert_true(hget_result is Ok("value1"))

  // 清理 
  let _ = client.del([key])
}

///|
/// 测试HDEL命令
async test "hash_hdel" {
  let client = connect("localhost", 6379)
  defer client.close()
  let key = hash_test_key("hdel")
  let _ = client.del([key])

  // 设置测试数据
  let _ = client.hset(key, "field1", "value1")
  let _ = client.hset(key, "field2", "value2")

  // 测试HDEL
  let hdel_result = client.hdel(key, ["field1"])
  debug_inspect(hdel_result is Ok(1), content="true")

  // 清理 
  let _ = client.del([key])
}

///|
/// 测试HKEYS和HVALS命令
async test "hash_hkeys_hvals" {
  let client = connect("localhost", 6379)
  defer client.close()
  let key = hash_test_key("hkeys_hvals")
  let _ = client.del([key])

  // 设置测试数据
  let _ = client.hset(key, "field1", "value1")
  let _ = client.hset(key, "field2", "value2")

  // 测试HKEYS
  let hkeys_result = client.hkeys(key)
  assert_true(hkeys_result is Ok(_))

  // 测试HVALS
  let hvals_result = client.hvals(key)
  assert_true(hvals_result is Ok(_))

  // 清理
  let _ = client.del([key])
}

///|
/// 测试HGETALL命令
async test "hash_hgetall" {
  let client = connect("localhost", 6379)
  defer client.close()
  let key = hash_test_key("hgetall")
  let _ = client.del([key])

  // 设置测试数据
  let _ = client.hset(key, "field1", "value1")
  let _ = client.hset(key, "field2", "value2")

  // 测试HGETALL
  let hgetall_result = client.hgetall(key)
  assert_true(hgetall_result is Ok(_))

  // 清理
  let _ = client.del([key])
}

///|
/// 测试HEXISTS和HLEN命令
async test "hash_hexists_hlen" {
  let client = connect("localhost", 6379)
  defer client.close()
  let key = hash_test_key("hexists_hlen")
  let _ = client.del([key])

  // 设置测试数据
  let _ = client.hset(key, "field1", "value1")
  let _ = client.hset(key, "field2", "value2")

  // 测试HEXISTS - 存在的字段
  let hexists_result1 = client.hexists(key, "field1")
  assert_true(hexists_result1 is Ok(true))

  // 测试HEXISTS - 不存在的字段
  let hexists_result2 = client.hexists(key, "nonexistent")
  assert_true(hexists_result2 is Ok(false))

  // 测试HLEN
  let hlen_result = client.hlen(key)
  assert_true(hlen_result is Ok(2))

  // 清理
  let _ = client.del([key])
}

///|
/// 测试HSET多个字段
async test "hash_multiple_fields" {
  let client = connect("localhost", 6379)
  defer client.close()
  let key = hash_test_key("multiple_fields")
  let _ = client.del([key])

  // 设置多个字段
  let _ = client.hset(key, "field1", "value1")
  let _ = client.hset(key, "field2", "value2")
  let _ = client.hset(key, "field3", "value3")

  // 验证字段数量
  let hlen_result = client.hlen(key)
  debug_inspect(hlen_result is Ok(3), content="true")

  // 清理
  let _ = client.del([key])
}

///|
/// 测试hash字段操作
async test "hash_field_operations" {
  let client = connect("localhost", 6379)
  defer client.close()
  let key = hash_test_key("field_operations")
  let _ = client.del([key])

  // 设置字段
  let _ = client.hset(key, "name", "Alice")
  let _ = client.hset(key, "age", "25")

  // 检查字段是否存在
  let exists_result = client.hexists(key, "name")
  assert_true(exists_result is Ok(true))

  // 获取字段值
  let get_result = client.hget(key, "name")
  assert_true(get_result is Ok("Alice"))

  // 清理
  let _ = client.del([key])
}
