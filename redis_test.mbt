///|
async test "ping" {
  @async.with_task_group(async fn(_root) {
    let client = @redis.connect("localhost", 6379)
    defer client.close()
    let pong = client.ping()
    assert_true(pong is Ok("PONG"))
  })
}
