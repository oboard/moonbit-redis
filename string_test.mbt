///|
/// String命令测试套件
async test "string_ping" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()
    let pong = client.ping()
    assert_true(pong is Ok("PONG"))
  })
}

///|
/// 测试SET和GET命令
async test "string_set_get" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 测试SET
    let set_result = client.set("test:string", "hello_world")
    assert_true(set_result is Ok("OK"))

    // 测试GET
    let get_result = client.get("test:string")
    assert_true(get_result is Ok("hello_world"))

    // 清理
    let _ = client.del(["test:string"])

  })
}

///|
/// 测试APPEND命令
async test "string_append" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 设置初始值
    let _ = client.set("test:string", "hello")

    // 测试APPEND
    let append_result = client.append("test:string", "_world")
    assert_true(append_result is Ok(11)) // "hello_world"的长度

    // 验证结果
    let get_result = client.get("test:string")
    assert_true(get_result is Ok("hello_world"))

    // 清理
    let _ = client.del(["test:string"])

  })
}

///|
/// 测试INCR和DECR命令
async test "string_incr_decr" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 设置初始值
    let _ = client.set("test:counter", "10")

    // 测试INCR
    let incr_result = client.incr("test:counter")
    assert_true(incr_result is Ok(11))

    // 测试DECR
    let decr_result = client.decr("test:counter")
    assert_true(decr_result is Ok(10))

    // 清理
    let _ = client.del(["test:counter"])

  })
}

///|
/// 测试STRLEN命令
async test "string_strlen" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 设置测试值
    let _ = client.set("test:string", "hello")

    // 测试STRLEN
    let strlen_result = client.strlen("test:string")
    assert_true(strlen_result is Ok(5))

    // 清理
    let _ = client.del(["test:string"])

  })
}

///|
/// 测试MSET和MGET命令
async test "string_mset_mget" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 测试MSET
    let mset_result = client.mset({ "key1": "value1", "key2": "value2" })
    assert_true(mset_result is Ok("OK"))

    // 测试MGET
    let mget_result = client.mget(["key1", "key2"])
    assert_true(mget_result is Ok(["value1", "value2"]))

    // 清理
    let _ = client.del(["key1", "key2"])

  })
}
