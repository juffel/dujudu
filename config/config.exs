# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :dujudu,
  ecto_repos: [Dujudu.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :dujudu, DujuduWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: DujuduWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Dujudu.PubSub,
  live_view: [signing_salt: System.get_env("LIVEVIEW_SECRET_SALT")]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :dujudu, Dujudu.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tesla, :adapter, Tesla.Adapter.Hackney

config :flop, repo: Dujudu.Repo

config :dujudu, Dujudu.Auth.Guardian, secret_key: System.get_env("GUARDIAN_SECRET_KEY")

config :dujudu, Dujudu.Auth.Pipeline,
  module: Dujudu.Auth.Guardian,
  error_handler: Dujudu.Auth.ErrorHandler

config :dujudu, wikidata_request_cache_directory: "tmp/wikidata_client_cache"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
