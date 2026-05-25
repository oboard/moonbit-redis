///|
async test "ping" {
  let client = @redis.connect("localhost", 6379)
  defer client.close()
  let pong = client.ping()
  assert_true(pong is Ok("PONG"))
}

///|
test "mixed array response conversion" {
  let value = parse_redis_response(
    "*4\r\n$6\r\nlength\r\n:1\r\n$11\r\nfirst-entry\r\n*2\r\n$3\r\nid1\r\n$5\r\nfield\r\n",
  )
  assert_true(
    value.to_array() is Ok(["length", "1", "first-entry", "[id1, field]"]),
  )
}
