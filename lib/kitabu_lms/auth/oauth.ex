defmodule KitabuLms.Auth.OAuth do
  @moduledoc """
  OAuth authentication module for Google and GitHub.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias KitabuLms.Accounts.User
  alias KitabuLms.Repo

  schema "oauth_providers" do
    field(:provider, :string)
    field(:uid, :string)
    field(:token, :string)
    field(:refresh_token, :string)
    field(:expires_at, :utc_datetime)

    belongs_to(:user, User)

    timestamps()
  end

  @doc """
  Creates or updates an OAuth provider association for a user.
  """
  def create_or_update_provider(user, provider, uid, token_info \\ %{}) do
    oauth_provider =
      Repo.get_by(__MODULE__, user_id: user.id, provider: provider) ||
        Repo.get_by(__MODULE__, provider: provider, uid: uid) ||
        %__MODULE__{}

    attrs = %{
      provider: provider,
      uid: uid,
      token: token_info[:token],
      refresh_token: token_info[:refresh_token],
      expires_at: token_info[:expires_at]
    }

    oauth_provider
    |> change(attrs)
    |> put_assoc(:user, user)
    |> Repo.insert_or_update()
  end

  @doc """
  Finds a user by OAuth provider.
  """
  def find_by_provider(provider, uid) do
    case Repo.get_by(__MODULE__, provider: provider, uid: uid) do
      nil -> nil
      oauth_provider -> Repo.preload(oauth_provider, :user)
    end
  end

  @doc """
  Changeset for OAuth provider.
  """
  def changeset(oauth_provider, attrs) do
    oauth_provider
    |> cast(attrs, [:provider, :uid, :token, :refresh_token, :expires_at])
    |> validate_required([:provider, :uid])
    |> unique_constraint([:provider, :uid])
  end

  @doc """
  Generates OAuth configuration for Ueberauth.
  """
  def google_config do
    %{
      client_id: System.get_env("GOOGLE_CLIENT_ID"),
      client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
      redirect_uri:
        System.get_env("GOOGLE_REDIRECT_URI", "http://localhost:4000/auth/google/callback")
    }
  end

  def github_config do
    %{
      client_id: System.get_env("GITHUB_CLIENT_ID"),
      client_secret: System.get_env("GITHUB_CLIENT_SECRET"),
      redirect_uri:
        System.get_env("GITHUB_REDIRECT_URI", "http://localhost:4000/auth/github/callback")
    }
  end
end
