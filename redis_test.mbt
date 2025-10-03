///|
async test "connect" {
  @async.with_task_group(fn(_root) {
    let client = @redis.connect("localhost", 6379)
    defer client.close()
    let pong = client.ping()
    inspect(pong, content="+PONG\r\n")
  })
}
