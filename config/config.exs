# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :blurble,
  ecto_repos: [Blurble.Repo]

# Configures the endpoint
config :blurble, BlurbleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "y1VAoFigoTGOEQ5NSE+IZiTEWRuWin+uVda8WawHOoP9aFsjC1lcmidFrcFnQJwo",
  render_errors: [view: BlurbleWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Blurble.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "SECRET_SALT"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :blurble, Blurble.UserManager.Guardian,
  issuer: "blurble",
  secret_key: System.get_env("JWT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
