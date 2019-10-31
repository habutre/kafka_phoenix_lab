defmodule KafkaPhoenixLab.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # List all child processes to be supervised
    kafka_new_sup_api = [
      # Start the endpoint when the application starts
      KafkaPhoenixLabWeb.Endpoint,
      # Starts a worker by calling: KafkaPhoenixLab.Worker.start_link(arg)
      # {KafkaPhoenixLab.Worker, arg},
      {KafkaEx.ConsumerGroup,
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
       ]}
    ]

    # use in case local kafka_ex dep is reloaded and lose the start_link/1
    kafka_old_sup_api =
      supervisor(
        KafkaEx.ConsumerGroup,
        [
          KafkaPhoenixLab.Messaging.InteractionConsumer,
          "kafka-phoenix-lab-consumer",
          ["interactions"],
          [
            commit_interval: 3000,
            commit_threshold: 100,
            enable_auto_commit: true,
            auto_offset_reset: :latest,
            heartbeat_interval: 1_000
          ]
        ]
      )

    # skip for while the new supervisor API
    children = [kafka_old_sup_api]

    #IO.inspect(Mix.env(), label: "MIx checking=")

    #children =
    #  if Mix.env() == :test do
    #    children = [kafka_old_sup_api] ++ kafka_new_sup_api
    #  else
    #    children = [kafka_old_sup_api]
    #  end

    #IO.inspect(children)

    # TODO supervise me
    Process.register(KafkaPhoenixLab.Damage.DamageManagement.start(nil), :damage_mngt)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KafkaPhoenixLab.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # ---

  # @doc """
  #  Conformist start_link to Supervisor //TODO create a PR if works
  # """
  # @spec start_link([]) :: Supervisor.on_start()
  # def start_link(args \\ []) do
  #  consumer_module = Enum.at(args, 0)
  #  group_name = Enum.at(args, 1)
  #  topics = Enum.at(args, 2)
  #  opts = Enum.at(args, 3)

  #  {supervisor_opts, module_opts} =
  #    Keyword.split(opts, [:name, :strategy, :max_restarts, :max_seconds])

  #  Supervisor.start_link(
  #    __MODULE__,
  #    {consumer_module, group_name, topics, module_opts},
  #    supervisor_opts
  #  )
  # end
  # ---

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    KafkaPhoenixLabWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  # ---
  defp kafka_consumer_group_opts do
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
  end
end
