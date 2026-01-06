defmodule KitabuLmsWeb.Auth.OAuthLive do
  @moduledoc """
  OAuth callback and account linking LiveView.
  """
  use KitabuLmsWeb, :live_view

  alias KitabuLms.Auth
  alias KitabuLms.Auth.OAuth
  alias KitabuLms.Accounts.User

  def mount(%{"provider" => provider}, _session, socket) do
    {:ok,
     assign(socket,
       provider: provider,
       loading: true,
       error: nil,
       user: nil
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex items-center justify-center bg-neutral-50 px-4 py-12 sm:px-6 lg:px-8">
      <div class="max-w-md w-full space-y-8">
        <div class="text-center">
          <.link navigate={~p"/"} class="flex justify-center">
            <img src={~p"/images/logo.svg"} alt="Kitabu LMS" class="h-12 w-auto" />
          </.link>

          <h2 :if={@loading} class="mt-6 font-display text-3xl font-bold text-neutral-900">
            Connecting to {@provider}
          </h2>
          <h2 :if={@error} class="mt-6 font-display text-3xl font-bold text-neutral-900">
            Connection failed
          </h2>
          <h2
            :if={@user && !@loading && !@error}
            class="mt-6 font-display text-3xl font-bold text-neutral-900"
          >
            Account linked
          </h2>

          <p :if={@loading} class="mt-2 text-sm text-neutral-600">
            Please wait while we connect your account...
          </p>

          <p :if={@error} class="mt-2 text-sm text-neutral-600">
            {@error}
          </p>

          <p :if={@user && !@loading && !@error} class="mt-2 text-sm text-neutral-600">
            Your {@provider} account has been linked successfully.
          </p>
        </div>

        <div :if={@loading} class="text-center">
          <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-primary-100">
            <.icon name="hero-arrow-path" class="h-6 w-6 text-primary-600 animate-spin" />
          </div>
        </div>

        <div :if={@error} class="text-center">
          <.link navigate={~p"/sign-in"} class="font-medium text-primary-600 hover:text-primary-500">
            Back to sign in
          </.link>
        </div>

        <div :if={@user && !@loading && !@error} class="text-center">
          <.primary_button
            phx-click={JS.navigate(~p"/instructor")}
            class="w-full flex justify-center py-2.5"
          >
            Continue to dashboard
          </.primary_button>
        </div>
      </div>
    </div>
    """
  end

  def handle_params(%{"provider" => provider} = params, _uri, socket) do
    case handle_oauth_callback(provider, params) do
      {:ok, user} ->
        {:noreply,
         assign(socket,
           loading: false,
           user: user
         )}

      {:error, reason} ->
        {:noreply,
         assign(socket,
           loading: false,
           error: reason
         )}
    end
  end

  defp handle_oauth_callback(provider, params) do
    email = params["email"] || "user@#{provider}.com"
    name = params["name"] || "OAuth User"

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

        case Auth.register_user(user_attrs) do
          {:ok, user} ->
            link_oauth_provider(user, provider, params)
            {:ok, user}

          {:error, _} ->
            {:error, "Failed to create account with #{provider}"}
        end

      user ->
        link_oauth_provider(user, provider, params)
        {:ok, user}
    end
  end

  defp generate_random_password do
    :crypto.strong_rand_bytes(16) |> Base.encode64()
  end

  defp link_oauth_provider(user, provider, params) do
    uid = params["uid"] || "#{provider}-#{user.id}"

    token_info = %{
      token: params["token"] || "oauth_token_#{System.unique_integer()}",
      refresh_token: params["refresh_token"],
      expires_at: params["expires_at"]
    }

    OAuth.create_or_update_provider(user, provider, uid, token_info)
  end
end
