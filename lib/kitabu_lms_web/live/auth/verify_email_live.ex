defmodule KitabuLmsWeb.Auth.VerifyEmailLive do
  @moduledoc """
  Email verification LiveView.
  """
  use KitabuLmsWeb, :live_view

  def mount(%{"token" => token}, _session, socket) do
    case verify_email_token(token) do
      {:ok, user} ->
        {:ok,
         assign(socket,
           token: token,
           user: user,
           verified: true,
           error: nil
         )}

      {:error, reason} ->
        {:ok,
         assign(socket,
           token: nil,
           user: nil,
           verified: false,
           error: reason
         )}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex items-center justify-center bg-neutral-50 px-4 py-12 sm:px-6 lg:px-8">
      <div class="max-w-md w-full space-y-8">
        <div class="text-center">
          <.link navigate={~p"/"} class="flex justify-center">
            <img src={~p"/images/logo.svg"} alt="Kitabu LMS" class="h-12 w-auto" />
          </.link>

          <h2 :if={@verified} class="mt-6 font-display text-3xl font-bold text-neutral-900">
            Email verified!
          </h2>
          <h2
            :if={!@verified && !@error}
            class="mt-6 font-display text-3xl font-bold text-neutral-900"
          >
            Verifying...
          </h2>
          <h2 :if={@error} class="mt-6 font-display text-3xl font-bold text-neutral-900">
            Verification failed
          </h2>

          <p :if={@verified} class="mt-2 text-sm text-neutral-600">
            Your email has been verified successfully. You can now sign in to your account.
          </p>

          <p :if={@error} class="mt-2 text-sm text-neutral-600">
            {@error}
          </p>
        </div>

        <div :if={@verified} class="text-center">
          <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-green-100">
            <.icon name="hero-check" class="h-6 w-6 text-green-600" />
          </div>

          <div class="mt-6">
            <.primary_button
              phx-click={JS.navigate(~p"/sign-in")}
              class="w-full flex justify-center py-2.5"
            >
              Sign in
            </.primary_button>
          </div>
        </div>

        <div :if={@error} class="text-center">
          <.link navigate={~p"/join"} class="font-medium text-primary-600 hover:text-primary-500">
            Create a new account
          </.link>
        </div>
      </div>
    </div>
    """
  end

  defp verify_email_token(token) do
    # TODO: Implement actual email verification
    # This would:
    # 1. Look up the token in the database
    # 2. Verify the token is valid and not expired
    # 3. Mark the user's email as verified
    # 4. Invalidate the verification token

    # For demo purposes, accept tokens longer than 10 characters
    if token && String.length(token) > 10 do
      {:ok, %{email: "user@example.com", first_name: "User"}}
    else
      {:error, "This verification link is invalid or has expired."}
    end
  end
end
