// ============ JSON 命令测试 ============
// 需要 Redis 服务器 6.2 或以上版本 才能运行 JSON 命令

///|
/// 测试基础 JSON 操作：SET, GET, DEL, TYPE
async test "json basic operations" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 测试 JSON.SET 和 JSON.GET
    let set_result = client.json_set(
      "user:1", "$", "{\"name\":\"Alice\",\"age\":30}",
    )
    inspect(set_result, content="OK")
    let get_result = client.json_get("user:1", "$")
    inspect(get_result, content="[{\"name\":\"Alice\",\"age\":30}]")

    // 测试获取特定路径
    let name_result = client.json_get("user:1", "$.name")
    inspect(name_result, content="[\"Alice\"]")
    let age_result = client.json_get("user:1", "$.age")
    inspect(age_result, content="[30]")

    // 测试 JSON.TYPE
    let type_result = client.json_type("user:1", "$")
    inspect(type_result, content="object")
    let name_type = client.json_type("user:1", "$.name")
    inspect(name_type, content="string")
    let age_type = client.json_type("user:1", "$.age")
    inspect(age_type, content="integer")

    // 测试 JSON.DEL
    let del_result = client.json_del("user:1", "$.age")
    inspect(del_result, content="1")

    // 验证删除后的结果
    let after_del = client.json_get("user:1", "$")
    inspect(after_del, content="[{\"name\":\"Alice\"}]")

    // 清理
    let _ = client.json_del("user:1", "$")

  })
}

///|
/// 测试 JSON 数组操作
async test "json array operations" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 设置初始数组
    let _ = client.json_set("arr:1", "$", "[1,2,3]")

    // 测试 JSON.ARRLEN
    let len_result = client.json_arrlen("arr:1", "$")
    inspect(len_result, content="3")

    // 测试 JSON.ARRAPPEND
    let append_result = client.json_arrappend("arr:1", "$", ["4", "5"])
    inspect(append_result, content="5")
    let after_append = client.json_get("arr:1", "$")
    inspect(after_append, content="[1,2,3,4,5]")

    // 测试 JSON.ARRINSERT
    let insert_result = client.json_arrinsert("arr:1", "$", 2, ["\"inserted\""])
    inspect(insert_result, content="6")
    let after_insert = client.json_get("arr:1", "$")
    inspect(after_insert, content="[1,2,\"inserted\",3,4,5]")

    // 测试 JSON.ARRPOP
    let pop_result = client.json_arrpop("arr:1", "$", -1)
    inspect(pop_result, content="5")
    let after_pop = client.json_get("arr:1", "$")
    inspect(after_pop, content="[1,2,\"inserted\",3,4]")

    // 测试 JSON.ARRTRIM
    let trim_result = client.json_arrtrim("arr:1", "$", 1, 3)
    inspect(trim_result, content="3")
    let after_trim = client.json_get("arr:1", "$")
    inspect(after_trim, content="[2,\"inserted\",3]")

    // 清理
    let _ = client.json_del("arr:1", "$")

  })
}

///|
/// 测试 JSON 对象操作
async test "json object operations" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 设置初始对象
    let _ = client.json_set(
      "obj:1", "$", "{\"name\":\"Bob\",\"age\":25,\"city\":\"NYC\"}",
    )

    // 测试 JSON.OBJKEYS
    let keys_result = client.json_objkeys("obj:1", "$")
    inspect(keys_result, content="[\"name\",\"age\",\"city\"]")

    // 测试 JSON.OBJLEN
    let len_result = client.json_objlen("obj:1", "$")
    inspect(len_result, content="3")

    // 添加新字段
    let _ = client.json_set("obj:1", "$.country", "\"USA\"")
    let updated_keys = client.json_objkeys("obj:1", "$")
    inspect(updated_keys, content="[\"name\",\"age\",\"city\",\"country\"]")
    let updated_len = client.json_objlen("obj:1", "$")
    inspect(updated_len, content="4")

    // 清理
    let _ = client.json_del("obj:1", "$")

  })
}

///|
/// 测试 JSON 数值操作
async test "json numeric operations" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 设置初始数值
    let _ = client.json_set("num:1", "$", "{\"counter\":10,\"price\":99.99}")

    // 测试 JSON.NUMINCRBY
    let incr_result = client.json_numincrby("num:1", "$.counter", "5")
    inspect(incr_result, content="15")
    let after_incr = client.json_get("num:1", "$.counter")
    inspect(after_incr, content="[15]")

    // 测试 JSON.NUMMULTBY
    let mult_result = client.json_nummultby("num:1", "$.price", "1.1")
    inspect(mult_result, content="109.989")
    let after_mult = client.json_get("num:1", "$.price")
    inspect(after_mult, content="[109.989]")

    // 清理
    let _ = client.json_del("num:1", "$")

  })
}

///|
/// 测试 JSON 字符串操作
async test "json string operations" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 设置初始字符串
    let _ = client.json_set("str:1", "$", "{\"message\":\"Hello\"}")

    // 测试 JSON.STRLEN
    let len_result = client.json_strlen("str:1", "$.message")
    inspect(len_result, content="5")

    // 测试 JSON.STRAPPEND
    let append_result = client.json_strappend(
      "str:1", "$.message", "\" World\"",
    )
    inspect(append_result, content="11")
    let after_append = client.json_get("str:1", "$.message")
    inspect(after_append, content="[\"Hello World\"]")

    // 验证长度变化
    let new_len = client.json_strlen("str:1", "$.message")
    inspect(new_len, content="11")

    // 清理
    let _ = client.json_del("str:1", "$")

  })
}

///|
/// 测试 JSON 布尔值和其他操作
async test "json boolean and misc operations" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 设置初始布尔值
    let _ = client.json_set(
      "bool:1", "$", "{\"active\":true,\"verified\":false}",
    )

    // 测试 JSON.TOGGLE
    let toggle_result = client.json_toggle("bool:1", "$.active")
    inspect(toggle_result, content="1")
    let after_toggle = client.json_get("bool:1", "$.active")
    inspect(after_toggle, content="[false]")

    // 再次切换
    let _ = client.json_toggle("bool:1", "$.verified")
    let verified_after = client.json_get("bool:1", "$.verified")
    inspect(verified_after, content="[true]")

    // 测试 JSON.CLEAR
    let _ = client.json_set(
      "clear:1", "$", "{\"data\":[1,2,3],\"info\":{\"a\":1}}",
    )
    let clear_result = client.json_clear("clear:1", "$.data")
    inspect(clear_result, content="1")
    let after_clear = client.json_get("clear:1", "$.data")
    inspect(after_clear, content="[[]]")

    // 测试 JSON.FORGET (JSON.DEL 的别名)
    let forget_result = client.json_forget("bool:1", "$.active")
    inspect(forget_result, content="1")
    let after_forget = client.json_get("bool:1", "$")
    inspect(after_forget, content="[{\"verified\":true}]")

    // 清理
    let _ = client.json_del("bool:1", "$")
    let _ = client.json_del("clear:1", "$")

  })
}

///|
/// 测试错误情况和边界条件
async test "json error cases and edge conditions" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // 测试不存在的键
    let nonexistent = client.json_get("nonexistent:key", "$")
    inspect(nonexistent, content="null")

    // 测试无效路径
    let _ = client.json_set("edge:1", "$", "{\"valid\":\"data\"}")
    let invalid_path = client.json_get("edge:1", "$.invalid")
    inspect(invalid_path, content="[]")

    // 测试删除不存在的路径
    let del_invalid = client.json_del("edge:1", "$.nonexistent")
    inspect(del_invalid, content="0")

    // 测试空数组操作
    let _ = client.json_set("edge:2", "$", "[]")
    let empty_len = client.json_arrlen("edge:2", "$")
    inspect(empty_len, content="0")

    // 测试空对象操作
    let _ = client.json_set("edge:3", "$", "{}")
    let empty_obj_len = client.json_objlen("edge:3", "$")
    inspect(empty_obj_len, content="0")
    let empty_keys = client.json_objkeys("edge:3", "$")
    inspect(empty_keys, content="[]")

    // 清理
    let _ = client.json_del("edge:1", "$")
    let _ = client.json_del("edge:2", "$")
    let _ = client.json_del("edge:3", "$")

  })
}
