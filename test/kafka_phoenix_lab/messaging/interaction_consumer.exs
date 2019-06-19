defmodule KafkaPhoenixLab.Messaging.InteractionConsumer do
  use ExUnit.Case
  alias KafkaEx.Protocol.Produce.Message
  alias KafkaEx.Protocol.Produce.Request

  test "interaction message schema" do
    msg_payload = %Interaction{
      sent: 144,
      received: 7,
      timestamp: DateTime.from_iso8601("2019-05-01T10:38:47Z")
    }

    message = %Message{key: "elixir-pub", value: msg_payload}
    request = %Request{topic: "interactions", partition: 0, required_acks: 1, messages: [message]}

    assert request.messages.size == 1
  end
end
