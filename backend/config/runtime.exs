import Config
import Dotenvy

source!([".env", System.get_env()])

# Configure your database
config :backend, Backend.Repo,
  username: env!("POSTGRES_USER", :string),
  password: env!("POSTGRES_PASSWORD", :string),
  hostname: env!("POSTGRES_HOSTNAME", :string),
  port: env!("POSTGRES_PORT", :integer),
  database: env!("POSTGRES_DB", :string),
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :backend, Backend.Auth.Guardian,
  issuer: "E-Campus",
  secret_key: env!("JWT_TOKEN_SECRET", :string)

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/backend start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.
if System.get_env("PHX_SERVER") do
  config :backend, BackendWeb.Endpoint, server: true
end
