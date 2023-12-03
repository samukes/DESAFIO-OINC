# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :desafio_oinc,
  ecto_repos: [DesafioOinc.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the Commanded EventStore
config :desafio_oinc, DesafioOinc.App,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: DesafioOinc.EventStore
  ],
  pubsub: :local,
  registry: :local

config :desafio_oinc, event_stores: [DesafioOinc.EventStore]

# Configures the endpoint
config :desafio_oinc, DesafioOincWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [json: DesafioOincWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: DesafioOinc.PubSub,
  live_view: [signing_salt: "cTmvQllj"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
