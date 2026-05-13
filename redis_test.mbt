///|
async test "ping" {
  let client = @redis.connect("localhost", 6379)
  defer client.close()
  let pong = client.ping()
  assert_true(pong is Ok("PONG"))
}
