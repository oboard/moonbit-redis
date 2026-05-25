///| List命令测试套件

///|
fn list_test_key(name : String) -> String {
  "test:list:\{name}"
}

///|
/// 测试LPUSH和RPUSH命令
async test "list_push" {
  let client = connect("localhost", 6379)
  defer client.close()
  let key = list_test_key("push")
  let _ = client.del([key])

  // 测试LPUSH
  let lpush_result = client.lpush(key, ["item1", "item2"])
  assert_true(lpush_result is Ok(2))

  // 测试RPUSH
  let rpush_result = client.rpush(key, ["item3", "item4"])
  assert_true(rpush_result is Ok(4))

  // 清理
  let _ = client.del([key])
}

///|
/// 测试LPOP和RPOP命令
async test "list_pop" {
  let client = connect("localhost", 6379)
  defer client.close()
  let key = list_test_key("pop")
  let _ = client.del([key])

  // 准备数据
  let _ = client.rpush(key, ["item1", "item2", "item3"])

  // 测试LPOP
  let lpop_result = client.lpop(key)
  debug_inspect(lpop_result is Ok("item1"), content="true")

  // 测试RPOP
  let rpop_result = client.rpop(key)
  debug_inspect(rpop_result is Ok("item3"), content="true")

  // 清理
  let _ = client.del([key])
}

///|
/// 测试LLEN命令
async test "list_llen" {
  let client = connect("localhost", 6379)
  defer client.close()
  let key = list_test_key("llen")

  // 清理
  let _ = client.del([key])

  // 准备数据
  let _ = client.rpush(key, ["item1", "item2", "item3"])

  // 测试LLEN
  let llen_result = client.llen(key)
  assert_true(llen_result is Ok(3))

  // 清理
  let _ = client.del([key])
}

///|
/// 测试LRANGE命令
async test "list_lrange" {
  let client = connect("localhost", 6379)
  defer client.close()
  let key = list_test_key("lrange")

  // 清理
  let _ = client.del([key])
  // 准备数据
  let _ = client.rpush(key, ["item1", "item2", "item3"])

  // 测试LRANGE
  let lrange_result = client.lrange(key, start=0, stop=-1)
  assert_true(lrange_result is Ok(["item1", "item2", "item3"]))

  // 清理
  let _ = client.del([key])
}

///|
/// 测试LINDEX命令
async test "list_lindex" {
  let client = connect("localhost", 6379)
  defer client.close()
  let key = list_test_key("lindex")
  let _ = client.del([key])

  // 准备数据
  let _ = client.rpush(key, ["item1", "item2", "item3"])

  // 测试LINDEX
  let lindex_result = client.lindex(key, index=1)
  assert_true(lindex_result is Ok("item2"))

  // 清理
  let _ = client.del([key])
}

///|
/// 测试LREM命令
async test "list_lrem" {
  let client = connect("localhost", 6379)
  defer client.close()
  let key = list_test_key("lrem")
  let _ = client.del([key])

  // 准备数据
  let _ = client.rpush(key, ["item1", "item2", "item1", "item3"])

  // 测试LREM - 移除所有"item1"
  let lrem_result = client.lrem(key, count=0, value="item1")
  assert_true(lrem_result is Ok(2))

  // 验证剩余长度
  let llen_result = client.llen(key)
  assert_true(llen_result is Ok(2))

  // 清理
  let _ = client.del([key])
}
