defmodule KafkaPhoenixLabWeb.InteractionsChannel do
  use Phoenix.Channel
  alias KafkaPhoenixLab.Messaging.PlayerControlProducer

  def join("interactions:overview", _message, socket) do
    {:ok, socket}
  end

  def join("interactions:" <> _anyother_topic_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("elixir-damage", %{"damage" => damage}, socket) do
    broadcast!(socket, "elixir-damage", %{damage: damage})

    {:noreply, socket}
  end

  def handle_in("scala-damage", %{"damage" => damage}, socket) do
    broadcast!(socket, "scala-damage", %{damage: damage})

    {:noreply, socket}
  end

  def handle_in("player-control", msg, socket) do
    PlayerControlProducer.send_player_command(msg)

    {:noreply, socket}
  end
end
