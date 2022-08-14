import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :dujudu, Dujudu.Repo,
  username: "postgres",
  password: "postgres",
  hostname: System.get_env("POSTGRES_HOST", "db"),
  database: "dujudu_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dujudu, DujuduWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "VRmL26i+eUx4mazuGP0WKSAJRPFj51z+TYlBbLTNna2oR/ii+csWf++4+gAM+r7+",
  server: true

config :dujudu, :sandbox, Ecto.Adapters.SQL.Sandbox

# In test we don't send emails.
config :dujudu, Dujudu.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

config :tesla, adapter: Tesla.Mock

config :wallaby,
  otp_app: :dujudu,
  driver: Wallaby.Chrome,
  screenshot_on_failure: true

config :dujudu, :sandbox, Ecto.Adapters.SQL.Sandbox

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
