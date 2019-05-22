defmodule KafkaPhoenixLab.Repo do
  use Ecto.Repo,
    otp_app: :kafka_phoenix_lab,
    adapter: Ecto.Adapters.Postgres
end
