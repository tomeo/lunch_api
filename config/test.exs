import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :lunch_api, LunchApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "+Jr3dwKBZEOIVjdGSlHmIPNMAxhdZFB9HsBZqu5kIUQcsR/WxAvz3nEL2UlxSghN",
  server: false

# In test we don't send emails
config :lunch_api, LunchApi.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
