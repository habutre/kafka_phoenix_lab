defmodule KafkaPhoenixLab.Messaging.InteractionConsumer do
  use KafkaEx.GenConsumer
  require Logger

  defstruct [:sent, :received, :timestamp]

  def handle_message_set(message_set, state) do
    acc_state =
      for message <- message_set do
        publish_damage(message.key, String.to_integer(message.value))

        Logger.debug("The message content will be sent to view:" <> inspect(message))

        state
      end

    {:async_commit, acc_state}
  end

  defp publish_damage("elixir-damage" = key, damage) do
    Process.send(:damage_mngt, {key, damage}, [:noconnect])

    KafkaPhoenixLabWeb.Endpoint.broadcast!("interactions:overview", "elixir-damage", %{
      damage: damage
    })
  end

  defp publish_damage("scala-damage" = key, damage) do
    Process.send(:damage_mngt, {key, damage}, [:noconnect])

    KafkaPhoenixLabWeb.Endpoint.broadcast!("interactions:overview", "scala-damage", %{
      damage: damage
    })
  end

  defp publish_damage(key, _damage) do
    Logger.warn("Key #{key} is unknown")
  end
end
