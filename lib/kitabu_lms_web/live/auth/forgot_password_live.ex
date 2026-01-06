defmodule KitabuLmsWeb.Auth.ForgotPasswordLive do
  @moduledoc """
  Password recovery request LiveView.
  """
  use KitabuLmsWeb, :live_view

  def mount(_params, _session, socket) do
    case Guardian.Plug.current_resource(socket) do
      nil ->
        {:ok, assign(socket, form: to_form(%{"email" => ""}), submitted: false)}

      _user ->
        {:ok, redirect(socket, to: "/dashboard")}
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

          <h2 :if={!@submitted} class="mt-6 font-display text-3xl font-bold text-neutral-900">
            Forgot your password?
          </h2>
          <h2 :if={@submitted} class="mt-6 font-display text-3xl font-bold text-neutral-900">
            Check your email
          </h2>

          <p :if={!@submitted} class="mt-2 text-sm text-neutral-600">
            Enter your email address and we'll send you a link to reset your password.
          </p>

          <p :if={@submitted} class="mt-2 text-sm text-neutral-600">
            We've sent password reset instructions to your email address.
          </p>
        </div>

        <.form
          :if={!@submitted}
          for={@form}
          id="forgot-password-form"
          phx-submit="request_reset"
          class="mt-8 space-y-6"
        >
          <div>
            <label for="email" class="block text-sm font-medium text-neutral-700">
              Email address
            </label>
            <div class="mt-1">
              <.input
                field={@form[:email]}
                type="email"
                id="email"
                name="email"
                required
                placeholder="you@example.com"
                class="appearance-none block w-full px-3 py-2 border border-neutral-300 rounded-lg shadow-sm placeholder-neutral-400 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
              />
            </div>
          </div>

          <div>
            <.primary_button type="submit" class="w-full flex justify-center py-2.5">
              Send reset link
            </.primary_button>
          </div>
        </.form>

        <div :if={@submitted} class="text-center">
          <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-green-100">
            <.icon name="hero-check" class="h-6 w-6 text-green-600" />
          </div>
        </div>

        <div class="text-center">
          <.link navigate={~p"/sign-in"} class="font-medium text-primary-600 hover:text-primary-500">
            Back to sign in
          </.link>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("request_reset", %{"email" => email}, socket) do
    user = KitabuLms.Accounts.User.find_by_email(email)

    if user do
      # TODO: Generate reset token and send email
      # KitabuLms.Emails.send_password_reset_email(user, reset_token)
    end

    {:noreply, assign(socket, submitted: true)}
  end
end
