defmodule KafkaPhoenixLab.Messaging.InteractionConsumer do
  use KafkaEx.GenConsumer
  require Logger

  defstruct [:sent, :received, :timestamp]

  def handle_message_set(message_set, state) do
    for message <- message_set do
      Logger.debug("The message content will be sent to view:" <> inspect(message))
    end

    {:async_commit, state}
  end
end
