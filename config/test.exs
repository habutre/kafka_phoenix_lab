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
  brokers: [{"kafka", 19092}],
  use_ssl: true,
  ssl_options: [
    cacertfile: File.cwd!() <> "/dev/secrets/consumer-ca1-signed.crt",
    certfile: File.cwd!() <> "/dev/secrets/consumer.csr",
    keyfile: File.cwd!() <> "/dev/secrets/consumer_sslkey_creds"
  ]
