///|
async test "ping" {
  let client = @redis.connect("localhost", port=6379)
  defer client.close()
  let pong = client.ping()
  assert_true(pong is Ok("PONG"))
}

///|
async test "connect with db selects database" {
  let client = @redis.connect("localhost", port=6379, db=1)
  defer client.close()
  let pong = client.ping()
  assert_true(pong is Ok("PONG"))
  match client.client_list() {
    Ok(info) => assert_true(info.contains("db=1"))
    Err(e) => fail(e)
  }
}

///|
async test "connect with wrong password raises AuthFailed" {
  // 本地测试服务器未设置密码，对无密码服务器发送 AUTH 必然报错
  try {
    let client = @redis.connect(
      "localhost",
      port=6379,
      password="wrong_password",
    )
    client.close()
    fail("expected connect to raise AuthFailed")
  } catch {
    @redis.ConnectError::AuthFailed(_) => ()
    e => fail("unexpected error: \{e}")
  }
}

///|
async test "connect with unknown username raises AuthFailed" {
  // default 用户带 nopass 标记任何密码都能通过，
  // 但不存在的用户名一定会认证失败
  try {
    let client = @redis.connect(
      "localhost",
      port=6379,
      username="no_such_user",
      password="wrong_password",
    )
    client.close()
    fail("expected connect to raise AuthFailed")
  } catch {
    @redis.ConnectError::AuthFailed(_) => ()
    e => fail("unexpected error: \{e}")
  }
}

///|
async test "connect with out of range db raises SelectFailed" {
  try {
    let client = @redis.connect("localhost", port=6379, db=10086)
    client.close()
    fail("expected connect to raise SelectFailed")
  } catch {
    @redis.ConnectError::SelectFailed(_) => ()
    e => fail("unexpected error: \{e}")
  }
}

///|
test "mixed array response conversion" {
  let value = @redis.parse_redis_response(
    "*4\r\n$6\r\nlength\r\n:1\r\n$11\r\nfirst-entry\r\n*2\r\n$3\r\nid1\r\n$5\r\nfield\r\n",
  )
  assert_true(
    value.to_array() is Ok(["length", "1", "first-entry", "[id1, field]"]),
  )
}
