# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :around, AroundWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PxVpfcO5uV2MgfFSrT59oT2hyFknEzttdz4NDX2hlAZNkeDRCc1MIxghBH+28fjC",
  render_errors: [view: AroundWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Around.PubSub,
           pool_size: 1,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
