defmodule KitabuLms.Auth.Guardian do
  @moduledoc """
  Guardian configuration for JWT token authentication.
  """
  use Guardian,
    otp_app: :kitabu_lms,
    token_type: :access

  alias KitabuLms.Accounts.User
  alias KitabuLms.Repo

  @impl Guardian
  def subject_for_token(%User{id: id}, _claims) do
    {:ok, "user:#{id}"}
  end

  def subject_for_token(_, _) do
    {:error, :unknown_resource}
  end

  @impl Guardian
  def resource_from_claims(%{"sub" => "user:" <> user_id}) do
    case Repo.get(User, user_id) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :invalid_claims}
  end
end
