///|
async fn main {
  @async.with_task_group(fn(_root) {
    let redis_client = @redis.connect("127.0.0.1", 6379)
    defer redis_client.close()
    println("=== Redis 客户端完整测试套件 ===\n")

    // 清空数据库
    println("🧹 清空数据库...")
    let flush_result = redis_client.flushdb()
    println("FLUSHDB: \{parse_resp_response(flush_result)}\n")

    // 测试连接
    test_connection(redis_client)

    // 测试字符串命令
    test_string_commands(redis_client)

    // 测试列表命令
    test_list_commands(redis_client)

    // 测试哈希命令
    test_hash_commands(redis_client)

    // 测试集合命令
    test_set_commands(redis_client)

    // 测试有序集合命令
    test_sorted_set_commands(redis_client)

    // 测试通用命令
    test_generic_commands(redis_client)
    println("\n✅ 所有测试完成！")
  })
}

///|
async fn test_connection(client : @redis.RedisClient) -> Unit {
  println("🔗 测试连接...")
  let ping_result = client.ping()
  println("PING: \{parse_resp_response(ping_result)}")
  println("")
}

///|
async fn test_string_commands(client : @redis.RedisClient) -> Unit {
  println("📝 测试字符串命令...")

  // SET/GET
  let set_result = client.set("test_key", "hello_world")
  println("SET test_key hello_world: \{parse_resp_response(set_result)}")
  let get_result = client.get("test_key")
  println("GET test_key: \{parse_resp_response(get_result)}")

  // APPEND
  let append_result = client.append("test_key", "_appended")
  println("APPEND test_key _appended: \{parse_resp_response(append_result)}")
  let get_after_append = client.get("test_key")
  println(
    "GET test_key (after append): \{parse_resp_response(get_after_append)}",
  )

  // STRLEN
  let strlen_result = client.strlen("test_key")
  println("STRLEN test_key: \{parse_resp_response(strlen_result)}")

  // INCR/DECR
  let set_counter = client.set("counter", "10")
  println("SET counter 10: \{parse_resp_response(set_counter)}")
  let incr_result = client.incr("counter")
  println("INCR counter: \{parse_resp_response(incr_result)}")
  let incrby_result = client.incrby("counter", "5")
  println("INCRBY counter 5: \{parse_resp_response(incrby_result)}")
  let decr_result = client.decr("counter")
  println("DECR counter: \{parse_resp_response(decr_result)}")
  let decrby_result = client.decrby("counter", "3")
  println("DECRBY counter 3: \{parse_resp_response(decrby_result)}")
  println("")
}

///|
async fn test_list_commands(client : @redis.RedisClient) -> Unit {
  println("📋 测试列表命令...")

  // LPUSH/RPUSH
  let lpush_result = client.lpush("mylist", ["item1", "item2", "item3"])
  println(
    "LPUSH mylist item1 item2 item3: \{parse_resp_response(lpush_result)}",
  )
  let rpush_result = client.rpush("mylist", ["item4", "item5"])
  println("RPUSH mylist item4 item5: \{parse_resp_response(rpush_result)}")

  // LLEN
  let llen_result = client.llen("mylist")
  println("LLEN mylist: \{parse_resp_response(llen_result)}")

  // LRANGE
  let lrange_result = client.lrange("mylist", "0", "-1")
  println("LRANGE mylist 0 -1: \{parse_resp_response(lrange_result)}")

  // LINDEX
  let lindex_result = client.lindex("mylist", "0")
  println("LINDEX mylist 0: \{parse_resp_response(lindex_result)}")

  // LPOP/RPOP
  let lpop_result = client.lpop("mylist")
  println("LPOP mylist: \{parse_resp_response(lpop_result)}")
  let rpop_result = client.rpop("mylist")
  println("RPOP mylist: \{parse_resp_response(rpop_result)}")
  let lrange_after_pop = client.lrange("mylist", "0", "-1")
  println(
    "LRANGE mylist 0 -1 (after pop): \{parse_resp_response(lrange_after_pop)}",
  )
  println("")
}

///|
async fn test_hash_commands(client : @redis.RedisClient) -> Unit {
  println("🗂️ 测试哈希命令...")

  // HSET/HGET
  let hset_result = client.hset("user:1", "name", "Alice")
  println("HSET user:1 name Alice: \{parse_resp_response(hset_result)}")
  let hset_age = client.hset("user:1", "age", "25")
  println("HSET user:1 age 25: \{parse_resp_response(hset_age)}")
  let hset_city = client.hset("user:1", "city", "Beijing")
  println("HSET user:1 city Beijing: \{parse_resp_response(hset_city)}")
  let hget_result = client.hget("user:1", "name")
  println("HGET user:1 name: \{parse_resp_response(hget_result)}")

  // HGETALL
  let hgetall_result = client.hgetall("user:1")
  println("HGETALL user:1: \{parse_resp_response(hgetall_result)}")

  // HKEYS/HVALS
  let hkeys_result = client.hkeys("user:1")
  println("HKEYS user:1: \{parse_resp_response(hkeys_result)}")
  let hvals_result = client.hvals("user:1")
  println("HVALS user:1: \{parse_resp_response(hvals_result)}")

  // HLEN
  let hlen_result = client.hlen("user:1")
  println("HLEN user:1: \{parse_resp_response(hlen_result)}")

  // HEXISTS
  let hexists_result = client.hexists("user:1", "name")
  println("HEXISTS user:1 name: \{parse_resp_response(hexists_result)}")

  // HDEL
  let hdel_result = client.hdel("user:1", ["age"])
  println("HDEL user:1 age: \{parse_resp_response(hdel_result)}")
  let hgetall_after_del = client.hgetall("user:1")
  println(
    "HGETALL user:1 (after del): \{parse_resp_response(hgetall_after_del)}",
  )
  println("")
}

///|
async fn test_set_commands(client : @redis.RedisClient) -> Unit {
  println("🎯 测试集合命令...")

  // SADD
  let sadd_result = client.sadd("myset", ["member1", "member2", "member3"])
  println(
    "SADD myset member1 member2 member3: \{parse_resp_response(sadd_result)}",
  )

  // SMEMBERS
  let smembers_result = client.smembers("myset")
  println("SMEMBERS myset: \{parse_resp_response(smembers_result)}")

  // SCARD
  let scard_result = client.scard("myset")
  println("SCARD myset: \{parse_resp_response(scard_result)}")

  // SISMEMBER
  let sismember_result = client.sismember("myset", "member1")
  println("SISMEMBER myset member1: \{parse_resp_response(sismember_result)}")
  let sismember_false = client.sismember("myset", "nonexistent")
  println(
    "SISMEMBER myset nonexistent: \{parse_resp_response(sismember_false)}",
  )

  // SREM
  let srem_result = client.srem("myset", ["member2"])
  println("SREM myset member2: \{parse_resp_response(srem_result)}")
  let smembers_after_rem = client.smembers("myset")
  println(
    "SMEMBERS myset (after rem): \{parse_resp_response(smembers_after_rem)}",
  )
  println("")
}

///|
async fn test_sorted_set_commands(client : @redis.RedisClient) -> Unit {
  println("📊 测试有序集合命令...")

  // ZADD
  let zadd1 = client.zadd("leaderboard", "100", "player1")
  println("ZADD leaderboard 100 player1: \{parse_resp_response(zadd1)}")
  let zadd2 = client.zadd("leaderboard", "200", "player2")
  println("ZADD leaderboard 200 player2: \{parse_resp_response(zadd2)}")
  let zadd3 = client.zadd("leaderboard", "150", "player3")
  println("ZADD leaderboard 150 player3: \{parse_resp_response(zadd3)}")

  // ZRANGE
  let zrange_result = client.zrange("leaderboard", "0", "-1")
  println("ZRANGE leaderboard 0 -1: \{parse_resp_response(zrange_result)}")

  // ZSCORE
  let zscore_result = client.zscore("leaderboard", "player2")
  println("ZSCORE leaderboard player2: \{parse_resp_response(zscore_result)}")

  // ZCARD
  let zcard_result = client.zcard("leaderboard")
  println("ZCARD leaderboard: \{parse_resp_response(zcard_result)}")

  // ZREM
  let zrem_result = client.zrem("leaderboard", ["player1"])
  println("ZREM leaderboard player1: \{parse_resp_response(zrem_result)}")
  let zrange_after_rem = client.zrange("leaderboard", "0", "-1")
  println(
    "ZRANGE leaderboard 0 -1 (after rem): \{parse_resp_response(zrange_after_rem)}",
  )
  println("")
}

///|
async fn test_generic_commands(client : @redis.RedisClient) -> Unit {
  println("🔧 测试通用命令...")

  // 设置一些测试数据
  let _ = client.set("key1", "value1")
  let _ = client.set("key2", "value2")
  let _ = client.set("key3", "value3")

  // EXISTS
  let exists_result = client.exists(["key1", "key2", "nonexistent"])
  println("EXISTS key1 key2 nonexistent: \{parse_resp_response(exists_result)}")

  // KEYS
  let keys_result = client.keys("key*")
  println("KEYS key*: \{parse_resp_response(keys_result)}")

  // EXPIRE/TTL
  let expire_result = client.expire("key1", "10")
  println("EXPIRE key1 10: \{parse_resp_response(expire_result)}")
  let ttl_result = client.ttl("key1")
  println("TTL key1: \{parse_resp_response(ttl_result)}")
  let ttl_no_expire = client.ttl("key2")
  println("TTL key2 (no expire): \{parse_resp_response(ttl_no_expire)}")

  // DEL
  let del_result = client.del(["key2", "key3"])
  println("DEL key2 key3: \{parse_resp_response(del_result)}")
  let keys_after_del = client.keys("key*")
  println("KEYS key* (after del): \{parse_resp_response(keys_after_del)}")
  println("")
}

///|
/// Parse RESP response and return a readable string
fn parse_resp_response(response : String) -> String {
  if response.length() == 0 {
    return "(empty)"
  }
  let first_char = response[0]
  match first_char {
    '+' =>
      // Simple string: +PONG\r\n
      extract_line_content(response, 1)
    '-' =>
      // Error: -ERR message\r\n
      "ERROR: " + extract_line_content(response, 1)
    ':' =>
      // Integer: :1000\r\n
      extract_line_content(response, 1)
    '$' =>
      // Bulk string: $6\r\nfoobar\r\n or $-1\r\n (null)
      parse_bulk_string(response)
    '*' =>
      // Array: *count\r\n<element1><element2>...
      parse_array(response)
    _ => "Unknown response type"
  }
}

///|
/// Extract content from a line until \r\n
fn extract_line_content(text : String, start : Int) -> String {
  let mut i = start
  let len = text.length()
  let mut result = ""
  while i < len {
    let char_code = text[i]
    if char_code == '\r'.to_int() && i + 1 < len && text[i + 1] == '\n'.to_int() {
      break
    }
    result = result + char_code.unsafe_to_char().to_string()
    i = i + 1
  }
  result
}

///|
/// Parse bulk string response: $length\r\ncontent\r\n
fn parse_bulk_string(response : String) -> String {
  let length_str = extract_line_content(response, 1)

  // Check for null bulk string
  if length_str == "-1" {
    return "(nil)"
  }

  // Find where content starts (after $length\r\n)
  let mut content_start = 1
  while content_start < response.length() - 1 {
    if response[content_start] == '\r'.to_int() &&
      response[content_start + 1] == '\n'.to_int() {
      content_start = content_start + 2
      break
    }
    content_start = content_start + 1
  }

  // Extract content until next \r\n
  extract_line_content(response, content_start)
}

///|
/// Parse array response: *count\r\n<element1><element2>...
fn parse_array(response : String) -> String {
  let count_str = extract_line_content(response, 1)

  // Check for null array
  if count_str == "-1" {
    return "(nil)"
  }

  // For simplicity, just return the count for now
  // A full implementation would recursively parse each element
  "Array[\{count_str} elements]"
}
