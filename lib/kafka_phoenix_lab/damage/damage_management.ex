defmodule KafkaPhoenixLab.Damage.DamageManagement do
  require Logger

  alias KafkaPhoenixLab.Damage.DamageManagement

  # TODO superviser me pls!

  @derive [Jason.Encoder]
  defstruct scala_damage: 0, scala_shots: 0, elixir_damage: 0, elixir_shots: 0

  def start(initial_damage) do
    spawn(__MODULE__, :handle_management, [initial_damage])
  end

  def handle_management(state) do
    new_state =
      receive do
        {"scala-damage", value} ->
          Logger.info("calculate scala damage")
          calculate_scala_damage(value, state)

        {"elixir-damage", value} ->
          Logger.info("calculate elixir damage")
          calculate_elixir_damage(value, state)

        {key, _value} ->
          Logger.warn("Key #{key} not expected")
          state
      end

    # TODO move this code to web folder
    KafkaPhoenixLabWeb.Endpoint.broadcast!(
      "interactions:overview",
      "damage",
      new_state
    )

    handle_management([new_state])
  end

  defp calculate_scala_damage(value, state) when state == nil do
    %DamageManagement{scala_damage: value, scala_shots: 1}
  end

  defp calculate_scala_damage(value, state) do
    damage = List.first(state)
    %{damage | scala_damage: damage.scala_damage + value, scala_shots: damage.scala_shots + 1}
  end

  defp calculate_elixir_damage(value, state) when state == nil do
    %DamageManagement{elixir_damage: value, elixir_shots: 1}
  end

  defp calculate_elixir_damage(value, state) do
    damage = List.first(state)
    %{damage | elixir_damage: damage.elixir_damage + value, elixir_shots: damage.elixir_shots + 1}
  end
end
