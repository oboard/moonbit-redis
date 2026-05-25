///| Sorted Set命令测试套件

///|
fn sorted_set_test_key(name : String) -> String {
  "test:zset:\{name}"
}

///|
/// 测试ZADD和ZREM命令
async test "zset_zadd_zrem" {
  let client = connect("localhost", 6379)
  defer client.close()
  let key = sorted_set_test_key("zadd_zrem")
  let _ = client.del([key])

  // 测试ZADD - 使用批量添加
  let zadd_result = client.zadd(key, [
    { score: "1", value: "member1" },
    { score: "2", value: "member2" },
    { score: "3", value: "member3" },
  ])
  assert_true(zadd_result is Ok(3)) // 添加了3个成员

  // 测试ZREM
  let zrem_result = client.zrem(key, ["member1"])
  assert_true(zrem_result is Ok(1))

  // 清理
  let _ = client.del([key])
}

///|
/// 测试ZCARD命令
async test "zset_zcard" {
  let client = connect("localhost", 6379)
  defer client.close()
  let key = sorted_set_test_key("zcard")
  let _ = client.del([key])

  // 准备数据
  let _ = client.zadd(key, [
    { score: "1", value: "member1" },
    { score: "2", value: "member2" },
    { score: "3", value: "member3" },
  ])

  // 测试ZCARD
  let zcard_result = client.zcard(key)
  assert_true(zcard_result is Ok(3))

  // 清理
  let _ = client.del([key])
}

///|
/// 测试ZSCORE命令
async test "zset_zscore" {
  let client = connect("localhost", 6379)
  defer client.close()
  let key = sorted_set_test_key("zscore")
  let _ = client.del([key])

  // 准备数据
  let _ = client.zadd(key, [
    { score: "1.5", value: "member1" },
    { score: "2.5", value: "member2" },
  ])

  // 测试ZSCORE
  let zscore_result = client.zscore(key, "member1")
  assert_true(zscore_result is Ok("1.5"))

  // 清理
  let _ = client.del([key])
}

///|
/// 测试ZRANK命令
async test "zset_zrank" {
  let client = connect("localhost", 6379)
  defer client.close()
  let key = sorted_set_test_key("zrank")
  let _ = client.del([key])

  // 准备数据
  let _ = client.zadd(key, [
    { score: "1", value: "member1" },
    { score: "2", value: "member2" },
    { score: "3", value: "member3" },
  ])

  // 测试ZRANK
  let zrank_result = client.zrank(key, "member2")
  assert_true(zrank_result is Ok(1)) // 0-based index  

  // 清理
  let _ = client.del([key])
}

///|
/// 测试ZRANGE命令
async test "zset_zrange" {
  let client = connect("localhost", 6379)
  defer client.close()
  let key = sorted_set_test_key("zrange")
  let _ = client.del([key])

  // 准备数据
  let _ = client.zadd(key, [
    { score: "1", value: "member1" },
    { score: "2", value: "member2" },
    { score: "3", value: "member3" },
  ])

  // 测试ZRANGE
  let zrange_result = client.zrange(key, start="0", stop="-1")
  assert_true(zrange_result is Ok(["member1", "member2", "member3"]))

  // 清理
  let _ = client.del([key])
}

///|
/// 测试ZREVRANGE命令
async test "zset_zrevrange" {
  let client = connect("localhost", 6379)
  defer client.close()
  let key = sorted_set_test_key("zrevrange")
  let _ = client.del([key])

  // 准备数据
  let _ = client.zadd(key, [
    { score: "1", value: "member1" },
    { score: "2", value: "member2" },
    { score: "3", value: "member3" },
  ])

  // 测试ZREVRANGE
  let zrevrange_result = client.zrevrange(key, start="0", stop="-1")
  assert_true(zrevrange_result is Ok(["member3", "member2", "member1"]))

  // 清理
  let _ = client.del([key])
}

///|
/// 测试ZINCRBY命令
async test "zset_zincrby" {
  let client = connect("localhost", 6379)
  defer client.close()
  let key = sorted_set_test_key("zincrby")

  // 清理
  let _ = client.del([key])
  // 准备数据
  let _ = client.zadd(key, [{ score: "1", value: "member1" }])

  // 测试ZINCRBY
  let zincrby_result = client.zincrby(key, increment="2.5", value="member1")
  assert_true(zincrby_result is Ok("3.5"))

  // 验证新分数
  let zscore_result = client.zscore(key, "member1")
  assert_true(zscore_result is Ok("3.5"))

  // 清理
  let _ = client.del([key])
}
