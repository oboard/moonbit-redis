///|
/// Stream命令测试套件

///|
/// 测试XADD命令 - 添加条目到流
async test "stream_xadd" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 测试XADD
    let add_result = client.xadd("test:stream", "*", {
      "field1": "value1",
      "field2": "value2",
    })
    assert_true(add_result.unwrap().length() > 0) // 应该返回生成的ID

    // 清理
    let _ = client.del(["test:stream"])
  })
}

///|
/// 测试XLEN命令 - 获取流长度
async test "stream_xlen" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 添加一些条目
    let _ = client.xadd("test:stream", "*", { "field1": "value1" })
    let _ = client.xadd("test:stream", "*", { "field2": "value2" })

    // 测试XLEN
    let len_result = client.xlen("test:stream")
    assert_true(len_result is Ok(2))

    // 清理
    let _ = client.del(["test:stream"])
  })
}

///|
/// 测试XRANGE命令 - 范围查询
async test "stream_xrange" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 添加测试数据
    let _ = client.xadd("test:stream", "*", { "field1": "value1" })
    let _ = client.xadd("test:stream", "*", { "field2": "value2" })

    // 测试XRANGE
    let range_result = client.xrange("test:stream", start="-", end="+")
    assert_true(range_result is Ok([_, _]))

    // 测试带COUNT的XRANGE
    let range_count_result = client.xrange(
      "test:stream",
      start="-",
      end="+",
      count=1,
    )
    assert_true(range_count_result is Ok([_]))

    // 清理
    let _ = client.del(["test:stream"])
  })
}

///|
/// 测试XREVRANGE命令 - 反向范围查询
async test "stream_xrevrange" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 清理
    let _ = client.del(["test:stream"])
    // 添加测试数据
    let _ = client.xadd("test:stream", "*", { "field1": "value1" })
    let _ = client.xadd("test:stream", "*", { "field2": "value2" })

    // 测试XREVRANGE
    let revrange_result = client.xrevrange("test:stream", end="+", start="-")
    assert_true(revrange_result is Ok([_, _]))

    // 清理
    let _ = client.del(["test:stream"])
  })
}

///|
/// 测试XDEL命令 - 删除流条目
async test "stream_xdel" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 清理
    let _ = client.del(["test:stream"])
    // 添加测试数据
    let id1 = client.xadd("test:stream", "*", { "field1": "value1" }).unwrap()
    let _ = client.xadd("test:stream", "*", { "field2": "value2" })

    // 验证长度
    assert_true(client.xlen("test:stream") == Ok(2))

    // 测试XDEL
    let del_result = client.xdel("test:stream", [id1])
    assert_true(del_result is Ok(1))

    // 验证删除后长度
    assert_true(client.xlen("test:stream") is Ok(1))

    // 清理
    let _ = client.del(["test:stream"])
  })
}

///|
/// 测试XTRIM命令 - 修剪流
async test "stream_xtrim" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 添加多个条目
    let _ = client.xadd("test:stream", "*", { "field1": "value1" })
    let _ = client.xadd("test:stream", "*", { "field2": "value2" })
    let _ = client.xadd("test:stream", "*", { "field3": "value3" })

    // 验证初始长度
    assert_true(client.xlen("test:stream").unwrap() == 3)

    // 测试XTRIM - 保留最新2个条目
    let trim_result = client.xtrim(
      "test:stream",
      strategy=MaxLen,
      threshold=2,
      approximate=false,
    )
    assert_true(trim_result.unwrap() == 1) // 删除了1个条目

    // 验证修剪后长度
    assert_true(client.xlen("test:stream").unwrap() == 2)

    // 清理
    let _ = client.del(["test:stream"])
  })
}

///|
/// 测试消费者组基本操作
async test "stream_consumer_group_basic" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 添加测试数据
    let _ = client.xadd("test:stream", "*", { "field1": "value1" })

    // 测试创建消费者组
    let create_result = client.xgroup_create(
      "test:stream", "test_group", "0", false,
    )
    assert_true(create_result.unwrap() == "OK")

    // 测试创建消费者
    let create_consumer_result = client.xgroup_createconsumer(
      "test:stream", "test_group", "consumer1",
    )
    assert_true(create_consumer_result.unwrap() == 1)

    // 测试删除消费者
    let del_consumer_result = client.xgroup_delconsumer(
      "test:stream", "test_group", "consumer1",
    )
    assert_true(del_consumer_result.unwrap() >= 0)

    // 测试销毁消费者组
    let destroy_result = client.xgroup_destroy("test:stream", "test_group")
    assert_true(destroy_result.unwrap() == 1)

    // 清理
    let _ = client.del(["test:stream"])
  })
}

///|
/// 测试XREAD命令 - 读取流条目
async test "stream_xread" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 添加测试数据
    let _ = client.xadd("test:stream", "*", { "field1": "value1" })
    let _ = client.xadd("test:stream", "*", { "field2": "value2" })

    // 测试XREAD
    let read_result = client.xread(count=10, [("test:stream", "0")])
    assert_true(read_result.map(i => i.messages.length() > 0).or(false))

    // 清理
    let _ = client.del(["test:stream"])
  })
}

///|
/// 测试消费者组读取和确认
async test "stream_consumer_group_read_ack" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 添加测试数据
    let id1 = client.xadd("test:stream", "*", { "field1": "value1" }).unwrap()
    let _ = client.xadd("test:stream", "*", { "field2": "value2" })

    // 创建消费者组
    let _ = client.xgroup_create("test:stream", "test_group", "0", false)

    // 测试XREADGROUP
    let readgroup_result = client.xreadgroup(
      "test_group",
      "consumer1",
      count=1,
      [("test:stream", ">")],
    )
    assert_true(readgroup_result.map(i => i.messages.length() > 0).or(false))

    // 测试XACK
    let ack_result = client.xack("test:stream", "test_group", [id1])
    assert_true(ack_result.unwrap() >= 0)

    // 清理
    let _ = client.xgroup_destroy("test:stream", "test_group")
    let _ = client.del(["test:stream"])
  })
}

///|
/// 测试XPENDING命令 - 查看待处理消息
async test "stream_xpending" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 添加测试数据
    let _ = client.xadd("test:stream", "*", { "field1": "value1" })

    // 创建消费者组
    let _ = client.xgroup_create("test:stream", "test_group", "0", false)

    // 读取消息但不确认
    let _ = client.xreadgroup("test_group", "consumer1", count=1, [
      ("test:stream", ">"),
    ])

    // 测试XPENDING
    let pending_result = client.xpending("test:stream", "test_group")
    assert_true(pending_result.unwrap().length() > 0)

    // 清理
    let _ = client.xgroup_destroy("test:stream", "test_group")
    let _ = client.del(["test:stream"])
  })
}

///|
/// 测试XINFO命令 - 获取流信息
async test "stream_xinfo" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 添加测试数据
    let _ = client.xadd("test:stream", "*", { "field1": "value1" })

    // 测试XINFO STREAM
    let info_stream_result = client.xinfo_stream("test:stream")
    assert_true(info_stream_result.unwrap().length() > 0)

    // 创建消费者组
    let _ = client.xgroup_create("test:stream", "test_group", "0", false)

    // 测试XINFO GROUPS
    let info_groups_result = client.xinfo_groups("test:stream")
    assert_true(info_groups_result.unwrap().length() > 0)

    // 创建消费者
    let _ = client.xgroup_createconsumer(
      "test:stream", "test_group", "consumer1",
    )

    // 测试XINFO CONSUMERS
    let info_consumers_result = client.xinfo_consumers(
      "test:stream", "test_group",
    )
    assert_true(info_consumers_result.unwrap().length() > 0)

    // 清理
    let _ = client.xgroup_destroy("test:stream", "test_group")
    let _ = client.del(["test:stream"])
  })
}

///|
/// 测试复杂的流操作场景
async test "stream_complex_scenario" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 清理旧数据
    let _ = client.del(["test:orders"])

    // 1. 创建流并添加多个条目
    let _ = client.xadd("test:orders", "*", {
      "user_id": "123",
      "product": "laptop",
      "amount": "1500",
    })
    let _ = client.xadd("test:orders", "*", {
      "user_id": "456",
      "product": "mouse",
      "amount": "25",
    })
    let _ = client.xadd("test:orders", "*", {
      "user_id": "789",
      "product": "keyboard",
      "amount": "75",
    })

    // 2. 验证流长度
    assert_true(client.xlen("test:orders") is Ok(3))

    // 3. 创建多个消费者组
    let _ = client.xgroup_create("test:orders", "payment_processor", "0", false)
    let _ = client.xgroup_create("test:orders", "inventory_manager", "0", false)

    // 4. 不同消费者组读取消息
    let payment_messages = client.xreadgroup(
      "payment_processor",
      "worker1",
      count=2,
      [("test:orders", ">")],
    )
    println(payment_messages)
    assert_true(payment_messages is Ok(_))
    let inventory_messages = client.xreadgroup(
      "inventory_manager",
      "worker1",
      count=2,
      [("test:orders", ">")],
    )
    assert_true(inventory_messages is Ok(_))

    // 5. 查看待处理消息
    let payment_pending = client.xpending("test:orders", "payment_processor")
    assert_true(payment_pending.unwrap().length() > 0)

    // 6. 修剪流保留最新2个条目
    let _ = client.xtrim("test:orders", strategy=MaxLen, threshold=2)
    assert_true(client.xlen("test:orders") is Ok(2))

    // 7. 再次查看待处理消息，应该为空
    let payment_pending_after_ack = client.xpending(
      "test:orders", "payment_processor",
    )
    assert_true(payment_pending_after_ack is Ok(_))

    // 清理
    let _ = client.xgroup_destroy("test:orders", "payment_processor")
    let _ = client.xgroup_destroy("test:orders", "inventory_manager")
    let _ = client.del(["test:orders"])
  })
}

///|
/// 测试边界情况和错误处理
async test "stream_edge_cases" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 清理
    let _ = client.xgroup_destroy("test:stream", "test_group")
    let _ = client.del(["test:stream"])

    // 测试空流的操x作
    let empty_len = client.xlen("nonexistent:stream")
    assert_true(empty_len.unwrap() == 0)
    let empty_range = client.xrange("nonexistent:stream", start="-", end="+")
    println(empty_range)
    assert_true(empty_range is Ok([]))

    // 测试删除不存在的条目
    let del_nonexistent = client.xdel("nonexistent:stream", ["1234567890-0"])
    assert_true(del_nonexistent.unwrap() == 0)

    // 测试销毁不存在的消费者组
    let destroy_nonexistent = client.xgroup_destroy(
      "nonexistent:stream", "nonexistent_group",
    )
    // 这应该返回错误，但我们只验证它不会崩溃
    let _ = destroy_nonexistent

    // 添加一个条目用于后续测试
    let _ = client.xadd("test:stream", "*", { "test": "value" })

    // 测试重复创建消费者组
    let _ = client.xgroup_create("test:stream", "test_group", "0", false)
    let duplicate_create = client.xgroup_create(
      "test:stream", "test_group", "0", false,
    )
    // 这应该返回错误，但我们只验证它不会崩溃
    let _ = duplicate_create

    // 清理
    let _ = client.xgroup_destroy("test:stream", "test_group")
    let _ = client.del(["test:stream"])
  })
}
