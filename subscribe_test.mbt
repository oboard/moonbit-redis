/// Redis Subscribe/Unsubscribe functionality tests

///|
/// Test publish command
async test "publish command" {
  @async.with_task_group(fn(_root) {
    let client = connect("localhost", 6379)
    defer client.close()

    // Test publish to a channel
    let subscriber_count = client
      .publish("test_channel", "hello world")
      .unwrap()
    assert_true(subscriber_count >= 0)
  })
}

///|
async test "complex subscription scenario" {
  @async.with_task_group(fn(_root) {
    let client1 = connect("localhost", 6379)
    let client2 = connect("localhost", 6379)
    let client3 = connect("localhost", 6379)

    // Client 1: Subscribe to regular channels
    let _ = client1.subscribe(["news", "sports"])

    // Client 2: Subscribe to patterns
    let _ = client2.psubscribe(["news.*", "sports.*"])

    // Client 3: Publish messages
    let news_subscribers = client3.publish("news", "Breaking news!").unwrap()
    let sports_subscribers = client3.publish("sports", "Game results").unwrap()

    // Verify subscribers received messages (at least 1 each)
    assert_true(news_subscribers >= 1)
    assert_true(sports_subscribers >= 1)

    // Clean up subscriptions
    let _ = client1.unsubscribe()
    let _ = client2.punsubscribe()

  })
}
