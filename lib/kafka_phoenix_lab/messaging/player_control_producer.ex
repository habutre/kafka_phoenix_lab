defmodule KafkaPhoenixLab.Messaging.PlayerControlProducer do
  require Logger
  alias KafkaEx.Protocol.Produce.{Message, Request}

  def send_player_command(%{"elixir-player" => _} = command) do
    send_command("elixir", command["elixir-player"])
  end

  def send_player_control(%{"scala-player" => _} = command) do
    send_command("scala", command["scala-player"])
  end

  defp send_command(player, command) do
    msg = %Message{key: "#{player}-control", value: command}
    request = %Request{topic: "player-control", partition: 0, required_acks: 1, messages: [msg]}

    KafkaEx.produce(request)
    Logger.info(String.capitalize(command) <> " requested to " <> String.capitalize(player) <> " Player")
  end
end
