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

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
