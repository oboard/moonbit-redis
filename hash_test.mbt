///| Hash命令测试套件

///|
/// 测试HSET和HGET命令
async test "hash_hset_hget" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 测试HSET
    let hset_result = client.hset("test:hash", "field1", "value1")
    assert_true(hset_result is Ok(1))

    // 测试HGET
    let hget_result = client.hget("test:hash", "field1")
    assert_true(hget_result is Ok("value1"))

    // 清理 
    let _ = client.del(["test:hash"])

  })
}

///|
/// 测试HDEL命令
async test "hash_hdel" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 设置测试数据
    let _ = client.hset("test:hash", "field1", "value1")
    let _ = client.hset("test:hash", "field2", "value2")

    // 测试HDEL
    let hdel_result = client.hdel("test:hash", ["field1"])
    inspect(hdel_result is Ok(1), content="true")

    // 清理 
    let _ = client.del(["test:hash"])

  })
}

///|
/// 测试HKEYS和HVALS命令
async test "hash_hkeys_hvals" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 设置测试数据
    let _ = client.hset("test:hash", "field1", "value1")
    let _ = client.hset("test:hash", "field2", "value2")

    // 测试HKEYS
    let hkeys_result = client.hkeys("test:hash")
    assert_true(hkeys_result is Ok(_))

    // 测试HVALS
    let hvals_result = client.hvals("test:hash")
    assert_true(hvals_result is Ok(_))

    // 清理
    let _ = client.del(["test:hash"])

  })
}

///|
/// 测试HGETALL命令
async test "hash_hgetall" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 设置测试数据
    let _ = client.hset("test:hash", "field1", "value1")
    let _ = client.hset("test:hash", "field2", "value2")

    // 测试HGETALL
    let hgetall_result = client.hgetall("test:hash")
    assert_true(hgetall_result is Ok(_))

    // 清理
    let _ = client.del(["test:hash"])

  })
}

///|
/// 测试HEXISTS和HLEN命令
async test "hash_hexists_hlen" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 设置测试数据
    let _ = client.hset("test:hash", "field1", "value1")
    let _ = client.hset("test:hash", "field2", "value2")

    // 测试HEXISTS - 存在的字段
    let hexists_result1 = client.hexists("test:hash", "field1")
    assert_true(hexists_result1 is Ok(true))

    // 测试HEXISTS - 不存在的字段
    let hexists_result2 = client.hexists("test:hash", "nonexistent")
    assert_true(hexists_result2 is Ok(false))

    // 测试HLEN
    let hlen_result = client.hlen("test:hash")
    assert_true(hlen_result is Ok(2))

    // 清理
    let _ = client.del(["test:hash"])

  })
}

///|
/// 测试HSET多个字段
async test "hash_multiple_fields" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 设置多个字段
    let _ = client.hset("test:hash", "field1", "value1")
    let _ = client.hset("test:hash", "field2", "value2")
    let _ = client.hset("test:hash", "field3", "value3")

    // 验证字段数量
    let hlen_result = client.hlen("test:hash")
    inspect(hlen_result is Ok(3), content="true")

    // 清理
    let _ = client.del(["test:hash"])

  })
}

///|
/// 测试hash字段操作
async test "hash_field_operations" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 设置字段
    let _ = client.hset("test:hash", "name", "Alice")
    let _ = client.hset("test:hash", "age", "25")

    // 检查字段是否存在
    let exists_result = client.hexists("test:hash", "name")
    assert_true(exists_result is Ok(true))

    // 获取字段值
    let get_result = client.hget("test:hash", "name")
    assert_true(get_result is Ok("Alice"))

    // 清理
    let _ = client.del(["test:hash"])

  })
}
