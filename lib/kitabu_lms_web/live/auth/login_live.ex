defmodule KitabuLmsWeb.Auth.LoginLive do
  @moduledoc """
  User sign-in LiveView.
  """
  use KitabuLmsWeb, :live_view

  alias KitabuLms.Auth

  def mount(_params, _session, socket) do
    case Guardian.Plug.current_resource(socket) do
      nil ->
        {:ok, assign(socket, form: to_form(%{"email" => "", "password" => ""}))}

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
          <h2 class="mt-6 font-display text-3xl font-bold text-neutral-900">
            Welcome back
          </h2>
          <p class="mt-2 text-sm text-neutral-600">
            Sign in to continue learning
          </p>
        </div>

        <.form
          for={@form}
          id="login-form"
          phx-submit="sign_in"
          class="mt-8 space-y-6"
        >
          <div class="space-y-4">
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
              <label for="password" class="block text-sm font-medium text-neutral-700">
                Password
              </label>
              <div class="mt-1">
                <.input
                  field={@form[:password]}
                  type="password"
                  id="password"
                  name="password"
                  required
                  placeholder="Enter your password"
                  class="appearance-none block w-full px-3 py-2 border border-neutral-300 rounded-lg shadow-sm placeholder-neutral-400 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
                />
              </div>
            </div>
          </div>

          <div class="flex items-center justify-between">
            <div class="flex items-center">
              <input
                id="remember-me"
                name="remember-me"
                type="checkbox"
                class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-neutral-300 rounded"
              />
              <label for="remember-me" class="ml-2 block text-sm text-neutral-900">
                Remember me
              </label>
            </div>

            <div class="text-sm">
              <.link
                navigate={~p"/forgot-password"}
                class="font-medium text-primary-600 hover:text-primary-500"
              >
                Forgot your password?
              </.link>
            </div>
          </div>

          <div>
            <.primary_button type="submit" class="w-full flex justify-center py-2.5">
              Sign in
            </.primary_button>
          </div>
        </.form>

        <div class="relative">
          <div class="absolute inset-0 flex items-center">
            <div class="w-full border-t border-neutral-300"></div>
          </div>
          <div class="relative flex justify-center text-sm">
            <span class="px-2 bg-neutral-50 text-neutral-500">Or continue with</span>
          </div>
        </div>

        <div class="grid grid-cols-2 gap-3">
          <.link
            navigate={~p"/auth/google"}
            class="w-full inline-flex justify-center items-center px-4 py-2 border border-neutral-300 rounded-lg shadow-sm bg-white text-sm font-medium text-neutral-700 hover:bg-neutral-50 transition-colors"
          >
            <svg class="h-5 w-5 mr-2" viewBox="0 0 24 24" fill="currentColor">
              <path
                d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
                fill="#4285F4"
              />
              <path
                d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
                fill="#34A853"
              />
              <path
                d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
                fill="#FBBC05"
              />
              <path
                d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
                fill="#EA4335"
              />
            </svg>
            Google
          </.link>
          <.link
            navigate={~p"/auth/github"}
            class="w-full inline-flex justify-center items-center px-4 py-2 border border-neutral-300 rounded-lg shadow-sm bg-white text-sm font-medium text-neutral-700 hover:bg-neutral-50 transition-colors"
          >
            <svg class="h-5 w-5 mr-2" fill="currentColor" viewBox="0 0 24 24">
              <path
                fill-rule="evenodd"
                d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"
                clip-rule="evenodd"
              />
            </svg>
            GitHub
          </.link>
        </div>

        <div class="text-center">
          <p class="text-sm text-neutral-600">
            Don't have an account?
            <.link navigate={~p"/join"} class="font-medium text-primary-600 hover:text-primary-500">
              Join now
            </.link>
          </p>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("sign_in", %{"email" => email, "password" => password}, socket) do
    case Auth.authenticate(email, password) do
      {:ok, user, _token} ->
        socket =
          socket
          |> put_flash(:info, "Welcome back, #{user.first_name || user.email}!")
          |> redirect(to: "/dashboard")

        {:noreply, socket}

      {:error, :invalid_credentials} ->
        socket = put_flash(socket, :error, "Invalid email or password")

        {:noreply, assign(socket, form: to_form(%{"email" => email, "password" => ""}))}

      {:error, :account_inactive} ->
        socket = put_flash(socket, :error, "Your account is inactive. Please contact support.")

        {:noreply, assign(socket, form: to_form(%{"email" => email, "password" => ""}))}
    end
  end
end
