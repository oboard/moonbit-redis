# oboard/redis
moonbit-redis is a modern, high performance Redis client for MoonBit.

## Usage
### Basic Example
```moonbit
///|
async test "string_set_get" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // SET
    let set_result = client.set("test:string", "hello_world")
    assert_true(set_result is Result::Ok("OK"))

    // GET
    let get_result = client.get("test:string")
    assert_true(get_result is Result::Ok("hello_world"))

    // Cleanup
    let _ = client.del(["test:string"])

  })
}
```

### Ping
```moonbit
///|
async test "ping" {
  @async.with_task_group(fn(_root) {
    let client = @redis.connect("localhost", 6379)
    defer client.close()
    let pong = client.ping()
    assert_true(pong is Ok("PONG"))
  })
}
```