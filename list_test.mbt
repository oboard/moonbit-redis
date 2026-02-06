///| List命令测试套件

///|
/// 测试LPUSH和RPUSH命令
async test "list_push" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 测试LPUSH
    let lpush_result = client.lpush("test:list", ["item1", "item2"])
    assert_true(lpush_result is Ok(2))

    // 测试RPUSH
    let rpush_result = client.rpush("test:list", ["item3", "item4"])
    assert_true(rpush_result is Ok(4))

    // 清理
    let _ = client.del(["test:list"])
  })
}

///|
/// 测试LPOP和RPOP命令
async test "list_pop" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 准备数据
    let _ = client.rpush("test:list", ["item1", "item2", "item3"])

    // 测试LPOP
    let lpop_result = client.lpop("test:list")
    inspect(lpop_result is Ok("item1"), content="true")

    // 测试RPOP
    let rpop_result = client.rpop("test:list")
    inspect(rpop_result is Ok("item3"), content="true")

    // 清理
    let _ = client.del(["test:list"])
  })
}

///|
/// 测试LLEN命令
async test "list_llen" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 清理
    let _ = client.del(["test:list"])

    // 准备数据
    let _ = client.rpush("test:list", ["item1", "item2", "item3"])

    // 测试LLEN
    let llen_result = client.llen("test:list")
    assert_true(llen_result is Ok(3))

    // 清理
    let _ = client.del(["test:list"])
  })
}

///|
/// 测试LRANGE命令
async test "list_lrange" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 清理
    let _ = client.del(["test:list"])
    // 准备数据
    let _ = client.rpush("test:list", ["item1", "item2", "item3"])

    // 测试LRANGE
    let lrange_result = client.lrange("test:list", start=0, stop=-1)
    assert_true(lrange_result is Ok(["item1", "item2", "item3"]))

    // 清理
    let _ = client.del(["test:list"])
  })
}

///|
/// 测试LINDEX命令
async test "list_lindex" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 准备数据
    let _ = client.rpush("test:list", ["item1", "item2", "item3"])

    // 测试LINDEX
    let lindex_result = client.lindex("test:list", index=1)
    assert_true(lindex_result is Ok("item2"))

    // 清理
    let _ = client.del(["test:list"])
  })
}

///|
/// 测试LREM命令
async test "list_lrem" {
  @async.with_task_group(async fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 准备数据
    let _ = client.rpush("test:list", ["item1", "item2", "item1", "item3"])

    // 测试LREM - 移除所有"item1"
    let lrem_result = client.lrem("test:list", count=0, value="item1")
    assert_true(lrem_result is Ok(2))

    // 验证剩余长度
    let llen_result = client.llen("test:list")
    assert_true(llen_result is Ok(2))

    // 清理
    let _ = client.del(["test:list"])
  })
}
