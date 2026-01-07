# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# Load .env file in development and test environments
if Mix.env() in [:dev, :test] do
  env_file = Path.join([__DIR__, "..", ".env"])

  if File.exists?(env_file) do
    env_file
    |> File.read!()
    |> String.split("\n")
    |> Enum.each(fn line ->
      line = String.trim(line)

      if line != "" and not String.starts_with?(line, "#") and String.contains?(line, "=") do
        [key | value_parts] = String.split(line, "=", parts: 2)
        key = String.trim(key)
        value = String.trim(Enum.join(value_parts, "="))
        # Remove quotes if present
        value = String.trim(value, "\"")
        value = String.trim(value, "'")
        System.put_env(key, value)
      end
    end)
  end
end

# General application configuration
import Config

config :kitabu_lms,
  ecto_repos: [KitabuLms.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :kitabu_lms, KitabuLmsWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: KitabuLmsWeb.ErrorHTML, json: KitabuLmsWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: KitabuLms.PubSub,
  live_view: [signing_salt: "2kmjfwKu"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :kitabu_lms, KitabuLms.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.25.4",
  kitabu_lms: [
    args:
      ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.1.7",
  kitabu_lms: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Google, []},
    github: {Ueberauth.GitHub, []}
  ]

config :ueberauth, Ueberauth.Google,
  client_id: System.get_env("GOOGLE_CLIENT_ID") || "placeholder",
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET") || "placeholder",
  redirect_uri:
    System.get_env("GOOGLE_REDIRECT_URI") || "http://localhost:4000/auth/google/callback"

config :ueberauth, Ueberauth.GitHub,
  client_id: System.get_env("GITHUB_CLIENT_ID") || "placeholder",
  client_secret: System.get_env("GITHUB_CLIENT_SECRET") || "placeholder",
  redirect_uri:
    System.get_env("GITHUB_REDIRECT_URI") || "http://localhost:4000/auth/github/callback"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
