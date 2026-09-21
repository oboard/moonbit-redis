///| Set命令测试套件

///|
fn set_test_key(name : String) -> String {
  "test:set:\{name}"
}

///|
/// 测试SADD和SREM命令
async test "set_sadd_srem" {
  let client = @redis.connect("localhost", port=6379)
  defer client.close()
  let key = set_test_key("sadd_srem")
  let _ = client.del([key])

  // 测试SADD
  let sadd_result = client.sadd(key, ["member1", "member2", "member3"])
  assert_true(sadd_result is Ok(3))

  // 测试SREM
  let srem_result = client.srem(key, ["member1"])
  assert_true(srem_result is Ok(1))

  // 清理
  let _ = client.del([key])
}

///|
/// 测试SCARD命令
async test "set_scard" {
  let client = @redis.connect("localhost", port=6379)
  defer client.close()
  let key = set_test_key("scard")
  let _ = client.del([key])

  // 准备数据
  let _ = client.sadd(key, ["member1", "member2", "member3"])

  // 测试SCARD
  let scard_result = client.scard(key)
  debug_inspect(scard_result is Ok(3), content="true")

  // 清理
  let _ = client.del([key])
}

///|
/// 测试SISMEMBER命令
async test "set_sismember" {
  let client = @redis.connect("localhost", port=6379)
  defer client.close()
  let key = set_test_key("sismember")
  let _ = client.del([key])

  // 准备数据
  let _ = client.sadd(key, ["member1", "member2", "member3"])

  // 测试SISMEMBER - 存在的成员
  let sismember_result1 = client.sismember(key, "member1")
  debug_inspect(sismember_result1 is Ok(1), content="true")

  // 测试SISMEMBER - 不存在的成员
  let sismember_result2 = client.sismember(key, "member4")
  debug_inspect(sismember_result2 is Ok(0), content="true")

  // 清理
  let _ = client.del([key])
}

///|
/// 测试SMEMBERS命令
async test "set_smembers" {
  let client = @redis.connect("localhost", port=6379)
  defer client.close()
  let key = set_test_key("smembers")
  let _ = client.del([key])

  // 准备数据
  let _ = client.sadd(key, ["member1", "member2", "member3"])

  // 测试SMEMBERS
  let smembers_result = client.smembers(key)
  match smembers_result {
    Ok(members) =>
      assert_true(
        members.length() == 3 &&
        members.contains("member1") &&
        members.contains("member2") &&
        members.contains("member3"),
      )
    _ => assert_true(false)
  }

  // 清理
  let _ = client.del([key])
}

///|
/// 测试SPOP命令
async test "set_spop" {
  let client = @redis.connect("localhost", port=6379)
  defer client.close()
  let key = set_test_key("spop")
  let _ = client.del([key])

  // 准备数据
  let _ = client.sadd(key, ["member1", "member2", "member3"])

  // 测试SPOP
  let spop_result = client.spop(key)
  // 验证返回了一个成员（具体是哪个不确定）
  assert_true(spop_result is Ok(_))

  // 验证集合大小减少了
  let scard_result = client.scard(key)
  assert_true(scard_result is Ok(2))

  // 清理
  let _ = client.del([key])
}

///|
/// 测试SRANDMEMBER命令
async test "set_srandmember" {
  let client = @redis.connect("localhost", port=6379)
  defer client.close()
  let key = set_test_key("srandmember")

  // 清理
  let _ = client.del([key])
  // 准备数据
  let _ = client.sadd(key, ["member1", "member2", "member3"])

  // 测试SRANDMEMBER
  let srandmember_result = client.srandmember(key)
  // 验证返回了一个成员
  assert_true(srandmember_result is Ok(_))

  // 验证集合大小没有变化
  let scard_result = client.scard(key)
  assert_true(scard_result is Ok(3))

  // 清理
  let _ = client.del([key])
}
