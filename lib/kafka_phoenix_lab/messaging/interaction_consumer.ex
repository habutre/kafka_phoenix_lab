defmodule KafkaPhoenixLab.Messaging.InteractionConsumer do
  use KafkaEx.GenConsumer
  require Logger

  defstruct [:sent, :received, :timestamp]

  def handle_message_set(message_set, state) do
    for message <- message_set do
      publish_damage(message.key, message.value)
      Logger.debug("The message content will be sent to view:" <> inspect(message))
    end

    {:async_commit, state}
  end

  defp publish_damage("elixir-pub" = key, damage) do
      KafkaPhoenixLabWeb.Endpoint.broadcast!("interactions:overview", "elixir-damage", %{damage: damage})
  end

  defp publish_damage("scala-pub" = key, damage) do
      KafkaPhoenixLabWeb.Endpoint.broadcast!("interactions:overview", "scala-damage", %{damage: damage})
  end

  defp publish_damage(key, _damage) do
    Logger.warn("Key #{key} is unknown")
  end
end
