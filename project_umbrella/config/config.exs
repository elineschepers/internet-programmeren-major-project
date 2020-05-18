# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :project,
  ecto_repos: [Project.Repo]

config :project_web,
  ecto_repos: [Project.Repo],
  generators: [context_app: :project]
config :project, ProjectWeb.Gettext,
locales: ~w(en nl), 
default_locale: "nl"
# Configures the endpoint
config :project_web, ProjectWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "q0BTfvSxLVHjT07magsc5DiYJX4kDIKDRCQejCKmhcyPT6KXvT+WdldVVtdayn2I",
  render_errors: [view: ProjectWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ProjectWeb.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "A72qaKLt"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :project_web, ProjectWeb.Guardian,
  issuer: "project_web",
  secret_key: "/SItoJIf5PIIarQ44WAHhY/6KqUHTarkaFLbFCyLWLBw3SXQAGdLZjksFRWHy3hb" # paste input here