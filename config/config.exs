# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :lunch_api,
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :lunch_api, LunchApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: LunchApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: LunchApi.PubSub,
  live_view: [signing_salt: "MPrOA47n"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :lunch_api, LunchApi.Mailer, adapter: Swoosh.Adapters.Local

config :lunch_api, LunchApi.Cache,
  adapter: Nebulex.Adapters.Local,
  gc_interval: :timer.minutes(30)

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
