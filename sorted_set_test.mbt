///| Sorted Set命令测试套件

///|
/// 测试ZADD和ZREM命令
async test "zset_zadd_zrem" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 测试ZADD - 使用批量添加
    let zadd_result = client.zadd("test:zset", [
      { score: "1", value: "member1" },
      { score: "2", value: "member2" },
      { score: "3", value: "member3" },
    ])
    inspect(zadd_result is Integer(3), content="true") // 添加了3个成员

    // 测试ZREM
    let zrem_result = client.zrem("test:zset", ["member1"])
    inspect(zrem_result is Integer(1), content="true")

    // 清理
    let _ = client.del(["test:zset"])

  })
}

///|
/// 测试ZCARD命令
async test "zset_zcard" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 准备数据
    let _ = client.zadd("test:zset", [
      { score: "1", value: "member1" },
      { score: "2", value: "member2" },
      { score: "3", value: "member3" },
    ])

    // 测试ZCARD
    let zcard_result = client.zcard("test:zset")
    inspect(zcard_result is Integer(3), content="true")

    // 清理
    let _ = client.del(["test:zset"])

  })
}

///|
/// 测试ZSCORE命令
async test "zset_zscore" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 准备数据
    let _ = client.zadd("test:zset", [
      { score: "1.5", value: "member1" },
      { score: "2.5", value: "member2" },
    ])

    // 测试ZSCORE
    let zscore_result = client.zscore("test:zset", "member1")
    inspect(zscore_result is SimpleString("1.5"), content="true")

    // 清理
    let _ = client.del(["test:zset"])

  })
}

///|
/// 测试ZRANK命令
async test "zset_zrank" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 准备数据
    let _ = client.zadd("test:zset", [
      { score: "1", value: "member1" },
      { score: "2", value: "member2" },
      { score: "3", value: "member3" },
    ])

    // 测试ZRANK
    let zrank_result = client.zrank("test:zset", "member2")
    inspect(zrank_result is Integer(1), content="true") // 0-based index  

    // 清理
    let _ = client.del(["test:zset"])

  })
}

///|
/// 测试ZRANGE命令
async test "zset_zrange" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 准备数据
    let _ = client.zadd("test:zset", [
      { score: "1", value: "member1" },
      { score: "2", value: "member2" },
      { score: "3", value: "member3" },
    ])

    // 测试ZRANGE
    let zrange_result = client.zrange("test:zset", "0", "-1")
    inspect(zrange_result is SimpleString("member1"), content="true")
    inspect(zrange_result is SimpleString("member2"), content="true")
    inspect(zrange_result is SimpleString("member3"), content="true")

    // 清理
    let _ = client.del(["test:zset"])

  })
}

///|
/// 测试ZREVRANGE命令
async test "zset_zrevrange" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 准备数据
    let _ = client.zadd("test:zset", [
      { score: "1", value: "member1" },
      { score: "2", value: "member2" },
      { score: "3", value: "member3" },
    ])

    // 测试ZREVRANGE
    let zrevrange_result = client.zrevrange("test:zset", "0", "-1")
    assert_true(
      zrevrange_result
      is Array(
        [
          BulkString(Some("member3")),
          BulkString(Some("member2")),
          BulkString(Some("member1")),
        ]
      ),
    )

    // 清理
    let _ = client.del(["test:zset"])

  })
}

///|
/// 测试ZINCRBY命令
async test "zset_zincrby" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 清理
    let _ = client.del(["test:zset"])
    // 准备数据
    let _ = client.zadd("test:zset", [{ score: "1", value: "member1" }])

    // 测试ZINCRBY
    let zincrby_result = client.zincrby(
      "test:zset",
      increment="2.5",
      value="member1",
    )
    assert_true(zincrby_result is BulkString(Some("3.5")))

    // 验证新分数
    let zscore_result = client.zscore("test:zset", "member1")
    assert_true(zscore_result is BulkString(Some("3.5")))

    // 清理
    let _ = client.del(["test:zset"])

  })
}
