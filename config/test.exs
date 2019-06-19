use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kafka_phoenix_lab, KafkaPhoenixLabWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Kafka config
config :kafka_ex,
  brokers: [{"kafka", 9092}],
  use_ssl: false
