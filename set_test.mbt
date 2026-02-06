///| Set命令测试套件

///|
/// 测试SADD和SREM命令
async test "set_sadd_srem" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 测试SADD
    let sadd_result = client.sadd("test:set", ["member1", "member2", "member3"])
    assert_true(sadd_result is Ok(3))

    // 测试SREM
    let srem_result = client.srem("test:set", ["member1"])
    assert_true(srem_result is Ok(1))

    // 清理
    let _ = client.del(["test:set"])
  })
}

///|
/// 测试SCARD命令
async test "set_scard" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 准备数据
    let _ = client.sadd("test:set", ["member1", "member2", "member3"])

    // 测试SCARD
    let scard_result = client.scard("test:set")
    inspect(scard_result is Ok(3), content="true")

    // 清理
    let _ = client.del(["test:set"])
  })
}

///|
/// 测试SISMEMBER命令
async test "set_sismember" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 准备数据
    let _ = client.sadd("test:set", ["member1", "member2", "member3"])

    // 测试SISMEMBER - 存在的成员
    let sismember_result1 = client.sismember("test:set", "member1")
    inspect(sismember_result1 is Ok(1), content="true")

    // 测试SISMEMBER - 不存在的成员
    let sismember_result2 = client.sismember("test:set", "member4")
    inspect(sismember_result2 is Ok(0), content="true")

    // 清理
    let _ = client.del(["test:set"])
  })
}

///|
/// 测试SMEMBERS命令
async test "set_smembers" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 准备数据
    let _ = client.sadd("test:set", ["member1", "member2", "member3"])

    // 测试SMEMBERS
    let smembers_result = client.smembers("test:set")
    assert_true(smembers_result is Ok(["member1", "member2", "member3"]))

    // 清理
    let _ = client.del(["test:set"])
  })
}

///|
/// 测试SPOP命令
async test "set_spop" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 准备数据
    let _ = client.sadd("test:set", ["member1", "member2", "member3"])

    // 测试SPOP
    let spop_result = client.spop("test:set")
    // 验证返回了一个成员（具体是哪个不确定）
    assert_true(spop_result is Ok(_))

    // 验证集合大小减少了
    let scard_result = client.scard("test:set")
    assert_true(scard_result is Ok(2))

    // 清理
    let _ = client.del(["test:set"])
  })
}

///|
/// 测试SRANDMEMBER命令
async test "set_srandmember" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 清理
    let _ = client.del(["test:set"])
    // 准备数据
    let _ = client.sadd("test:set", ["member1", "member2", "member3"])

    // 测试SRANDMEMBER
    let srandmember_result = client.srandmember("test:set")
    // 验证返回了一个成员
    assert_true(srandmember_result is Ok(_))

    // 验证集合大小没有变化
    let scard_result = client.scard("test:set")
    assert_true(scard_result is Ok(3))

    // 清理
    let _ = client.del(["test:set"])
  })
}
