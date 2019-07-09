defmodule KafkaPhoenixLab.Messaging.PlayerControlProducer do
  require Logger

  def sent_player_command(%{"elixir-player" => "pause"}) do
    sent_command("elixir", "pause")
  end

  def sent_player_control(%{"scala-player" => "pause"}) do
    sent_command("scala", "pause")
  end

  def sent_player_command(%{"elixir-player" => "resume"}) do
    sent_command("elixir", "resume")
  end

  def sent_player_control(%{"scala-player" => "resume"}) do
    sent_command("scala", "resume")
  end

  defp sent_command(player, command) do
    msg = %Message{key: "#{player}-control", value: command}
    request = %Request{topic: "player-control", partition: 0, required_acks: 1, messages: [msg]}

    KafkaEx.produce(request)
    Logger.info(String.capitalize(command) <> " requested to " <> String.capitalize(player) <> " Player")
  end
end
