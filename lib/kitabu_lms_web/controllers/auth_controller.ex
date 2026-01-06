defmodule KitabuLmsWeb.AuthController do
  @moduledoc """
  Controller for handling authentication-related actions.
  """
  use KitabuLmsWeb, :controller

  plug(Ueberauth)

  alias KitabuLms.Auth, as: AuthContext
  alias KitabuLms.Auth.OAuth
  alias KitabuLms.Accounts.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => provider}) do
    handle_oauth_callback(conn, provider, auth)
  end

  def callback(%{assigns: %{ueberauth_failure: failure}} = conn, %{"provider" => provider}) do
    handle_oauth_failure(conn, provider, failure)
  end

  defp handle_oauth_callback(conn, provider, auth) do
    email = get_in(auth, [:info, :email])
    name = get_in(auth, [:info, :name]) || get_in(auth, [:info, :nickname]) || "OAuth User"

    case User.find_by_email(email) do
      nil ->
        user_attrs = %{
          email: email,
          first_name: name,
          last_name: "",
          password: generate_random_password(),
          is_email_verified: true,
          is_active: true
        }

        case AuthContext.register_user(user_attrs) do
          {:ok, user} ->
            link_oauth_provider(user, provider, auth)
            sign_in_user(conn, user)

          {:error, _reason} ->
            conn
            |> put_flash(:error, "Failed to create account with #{provider}")
            |> redirect(to: "/sign-in")
        end

      user ->
        link_oauth_provider(user, provider, auth)
        sign_in_user(conn, user)
    end
  end

  defp handle_oauth_failure(conn, provider, failure) do
    error_message = Map.get(failure, :message, "Authentication failed")

    conn
    |> put_flash(:error, "Failed to sign in with #{provider}: #{error_message}")
    |> redirect(to: "/sign-in")
  end

  defp link_oauth_provider(user, provider, auth) do
    token_info = %{
      token: get_in(auth, [:credentials, :token]),
      refresh_token: get_in(auth, [:credentials, :refresh_token]),
      expires_at: parse_expiry(get_in(auth, [:credentials, :expires_at]))
    }

    OAuth.create_or_update_provider(user, provider, auth.uid, token_info)
  end

  defp sign_in_user(conn, user) do
    AuthContext.encode_token(user)

    conn
    |> put_session(:current_user_id, user.id)
    |> put_flash(:info, "Welcome#{if(user.first_name, do: " #{user.first_name}", else: "")}!")
    |> redirect(to: "/instructor")
  end

  defp generate_random_password do
    :crypto.strong_rand_bytes(16) |> Base.encode64()
  end

  defp parse_expiry(nil), do: nil

  defp parse_expiry({_sign, {{year, month, day}, {hour, min, sec}}}) do
    DateTime.from_erl({{year, month, day}, {hour, min, sec}})
  end

  defp parse_expiry(seconds) when is_integer(seconds) do
    DateTime.from_unix(seconds)
  end
end
