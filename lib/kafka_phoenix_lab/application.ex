defmodule KafkaPhoenixLab.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      KafkaPhoenixLabWeb.Endpoint,
      # Starts a worker by calling: KafkaPhoenixLab.Worker.start_link(arg)
      # {KafkaPhoenixLab.Worker, arg},
      supervisor(
        KafkaEx.ConsumerGroup,
        [
          KafkaPhoenixLab.Messaging.InteractionConsumer,
          "kafka-phoenix-lab-consumer",
          ["interactions"],
          [
            commit_interval: 5000,
            commit_threshold: 100,
            enable_auto_commit: true,
            auto_offset_reset: :latest,
            heartbeat_interval: 1_000
          ]
        ]
      )
    ]

    # TODO supervise me
    Process.register(KafkaPhoenixLab.Damage.DamageManagement.start(nil), :damage_mngt)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KafkaPhoenixLab.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    KafkaPhoenixLabWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
