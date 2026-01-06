defmodule KitabuLmsWeb.Auth.ResetPasswordLive do
  @moduledoc """
  Password reset LiveView with token verification.
  """
  use KitabuLmsWeb, :live_view

  def mount(%{"token" => token}, _session, socket) do
    case validate_token(token) do
      {:ok, user_email} ->
        {:ok,
         assign(socket,
           token: token,
           user_email: user_email,
           form: to_form(%{"password" => "", "password_confirmation" => ""}),
           submitted: false
         )}

      {:error, reason} ->
        {:ok,
         assign(socket,
           token: nil,
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

          <h2
            :if={!@error && !@submitted}
            class="mt-6 font-display text-3xl font-bold text-neutral-900"
          >
            Reset your password
          </h2>
          <h2 :if={@submitted} class="mt-6 font-display text-3xl font-bold text-neutral-900">
            Password reset
          </h2>
          <h2 :if={@error} class="mt-6 font-display text-3xl font-bold text-neutral-900">
            Invalid link
          </h2>

          <p :if={!@error && !@submitted} class="mt-2 text-sm text-neutral-600">
            Enter your new password below.
          </p>

          <p :if={@submitted} class="mt-2 text-sm text-neutral-600">
            Your password has been reset successfully.
          </p>

          <p :if={@error} class="mt-2 text-sm text-neutral-600">
            {@error}
          </p>
        </div>

        <.form
          :if={!@error && !@submitted}
          for={@form}
          id="reset-password-form"
          phx-submit="reset_password"
          class="mt-8 space-y-6"
        >
          <div>
            <label for="password" class="block text-sm font-medium text-neutral-700">
              New password
            </label>
            <div class="mt-1">
              <.input
                field={@form[:password]}
                type="password"
                id="password"
                name="password"
                required
                placeholder="Enter new password"
                minlength="8"
                class="appearance-none block w-full px-3 py-2 border border-neutral-300 rounded-lg shadow-sm placeholder-neutral-400 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
              />
            </div>
          </div>

          <div>
            <label for="password_confirmation" class="block text-sm font-medium text-neutral-700">
              Confirm new password
            </label>
            <div class="mt-1">
              <.input
                field={@form[:password_confirmation]}
                type="password"
                id="password_confirmation"
                name="password_confirmation"
                required
                placeholder="Confirm new password"
                class="appearance-none block w-full px-3 py-2 border border-neutral-300 rounded-lg shadow-sm placeholder-neutral-400 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
              />
            </div>
          </div>

          <div>
            <.primary_button type="submit" class="w-full flex justify-center py-2.5">
              Reset password
            </.primary_button>
          </div>
        </.form>

        <div :if={@submitted} class="text-center">
          <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-green-100">
            <.icon name="hero-check" class="h-6 w-6 text-green-600" />
          </div>

          <div class="mt-4">
            <.primary_button
              phx-click={JS.navigate(~p"/sign-in")}
              class="w-full flex justify-center py-2.5"
            >
              Sign in with new password
            </.primary_button>
          </div>
        </div>

        <div :if={@error} class="text-center">
          <.link
            navigate={~p"/forgot-password"}
            class="font-medium text-primary-600 hover:text-primary-500"
          >
            Request a new reset link
          </.link>
        </div>

        <div :if={!@error && !@submitted} class="text-center">
          <.link navigate={~p"/sign-in"} class="font-medium text-primary-600 hover:text-primary-500">
            Back to sign in
          </.link>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("reset_password", params, socket) do
    %{"password" => password, "password_confirmation" => password_confirmation} = params

    if password != password_confirmation do
      {:noreply,
       assign(socket,
         form: to_form(params),
         error_message: "Passwords do not match"
       )}
    end

    case reset_password(socket.assigns.token, password) do
      {:ok, _user} ->
        {:noreply, assign(socket, submitted: true)}

      {:error, reason} ->
        {:noreply,
         assign(socket,
           error_message: reason
         )}
    end
  end

  defp validate_token(token) do
    # TODO: Implement actual token validation
    # This would verify the token and extract the user email
    # For now, we'll simulate a valid token
    if token && String.length(token) > 10 do
      {:ok, "user@example.com"}
    else
      {:error, "This password reset link is invalid or has expired."}
    end
  end

  defp reset_password(_token, _password) do
    # TODO: Implement actual password reset
    # This would:
    # 1. Verify the token is valid and not expired
    # 2. Find the user associated with the token
    # 3. Update the user's password
    # 4. Invalidate the reset token

    # Simulate successful password reset
    {:ok, nil}
  end
end
