# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :advance,
  ecto_repos: [Advance.Repo]

# Configures the endpoint
config :advance, AdvanceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FnAO/W9VvxoEXgDvoV0W135mfuiqyv4EsetirafUPjoEjVo7hlVBW7QrJFR2p9PZ",
  render_errors: [view: AdvanceWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Advance.PubSub,
  live_view: [signing_salt: "rdFuEyIQ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :waffle,
  # or Waffle.Storage.Local
  storage: Waffle.Storage.S3,
  # if using S3
  bucket: System.get_env("AWS_BUCKET_NAME")

# If using AWS:
config :ex_aws,
  json_codec: Jason,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION")

# config :advance, Advance.Mailer,
#   adapter: Bamboo.MandrillAdapter,
#   api_key: "my_api_key"

config :advance, Advance.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.mailtrap.io",
  hostname: "smtp.mailtrap.io",
  port: 2525,
  username: "c6e1dfa36eeef6",
  password: "20201b69793118",
  tls: :if_available,
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
  ssl: false,
  retries: 1,
  no_mx_lookups: false,
  auth: :allways

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
