defmodule KitabuLms.Repo do
  use Ecto.Repo,
    otp_app: :kitabu_lms,
    adapter: Ecto.Adapters.Postgres
end
