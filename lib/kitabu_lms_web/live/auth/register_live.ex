defmodule KitabuLmsWeb.Auth.RegisterLive do
  @moduledoc """
  User registration LiveView.
  """
  use KitabuLmsWeb, :live_view

  alias KitabuLms.Auth
  alias KitabuLms.Repo
  alias KitabuLms.Accounts.User
  alias KitabuLms.Tenants.Tenant
  alias KitabuLms.Accounts.Role

  def mount(_params, _session, socket) do
    case Guardian.Plug.current_resource(socket) do
      nil ->
        form = %{
          "first_name" => "",
          "last_name" => "",
          "email" => "",
          "password" => "",
          "password_confirmation" => ""
        }

        {:ok, assign(socket, form: to_form(form))}

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
            Create your account
          </h2>
          <p class="mt-2 text-sm text-neutral-600">
            Start your learning journey today
          </p>
        </div>

        <.form
          for={@form}
          id="register-form"
          phx-submit="register"
          class="mt-8 space-y-6"
        >
          <div class="space-y-4">
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label for="first_name" class="block text-sm font-medium text-neutral-700">
                  First name
                </label>
                <div class="mt-1">
                  <.input
                    field={@form[:first_name]}
                    type="text"
                    id="first_name"
                    name="first_name"
                    required
                    placeholder="John"
                    class="appearance-none block w-full px-3 py-2 border border-neutral-300 rounded-lg shadow-sm placeholder-neutral-400 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
                  />
                </div>
              </div>

              <div>
                <label for="last_name" class="block text-sm font-medium text-neutral-700">
                  Last name
                </label>
                <div class="mt-1">
                  <.input
                    field={@form[:last_name]}
                    type="text"
                    id="last_name"
                    name="last_name"
                    required
                    placeholder="Doe"
                    class="appearance-none block w-full px-3 py-2 border border-neutral-300 rounded-lg shadow-sm placeholder-neutral-400 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
                  />
                </div>
              </div>
            </div>

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
                  placeholder="At least 8 characters"
                  class="appearance-none block w-full px-3 py-2 border border-neutral-300 rounded-lg shadow-sm placeholder-neutral-400 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
                />
              </div>
            </div>

            <div>
              <label for="password_confirmation" class="block text-sm font-medium text-neutral-700">
                Confirm password
              </label>
              <div class="mt-1">
                <.input
                  field={@form[:password_confirmation]}
                  type="password"
                  id="password_confirmation"
                  name="password_confirmation"
                  required
                  placeholder="Confirm your password"
                  class="appearance-none block w-full px-3 py-2 border border-neutral-300 rounded-lg shadow-sm placeholder-neutral-400 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
                />
              </div>
            </div>
          </div>

          <div class="flex items-start">
            <input
              id="terms"
              name="terms"
              type="checkbox"
              required
              class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-neutral-300 rounded mt-0.5"
            />
            <label for="terms" class="ml-2 block text-sm text-neutral-600">
              I agree to the
              <.link navigate={~p"/terms"} class="font-medium text-primary-600 hover:text-primary-500">
                Terms of Service
              </.link>
              and
              <.link
                navigate={~p"/privacy"}
                class="font-medium text-primary-600 hover:text-primary-500"
              >
                Privacy Policy
              </.link>
            </label>
          </div>

          <div>
            <.primary_button type="submit" class="w-full flex justify-center py-2.5">
              Create account
            </.primary_button>
          </div>
        </.form>

        <div class="text-center">
          <p class="text-sm text-neutral-600">
            Already have an account?
            <.link navigate={~p"/sign-in"} class="font-medium text-primary-600 hover:text-primary-500">
              Sign in
            </.link>
          </p>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("register", params, socket) do
    %{"password" => password, "password_confirmation" => password_confirmation} = params

    if password != password_confirmation do
      socket = put_flash(socket, :error, "Passwords do not match")

      {:noreply, assign(socket, form: to_form(params))}
    else
      register_user(socket, params)
    end
  end

  defp register_user(socket, params) do
    tenant = Repo.get_by(Tenant, slug: "kitabu")
    role = Repo.get_by(Role, slug: "student")

    user_params =
      Map.merge(params, %{
        "tenant_id" => tenant.id,
        "role_id" => role.id
      })

    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, _token} = Auth.encode_token(user)

        socket =
          socket
          |> put_flash(:info, "Account created successfully! Welcome to Kitabu LMS.")
          |> redirect(to: "/dashboard")

        {:noreply, socket}

      {:error, changeset} ->
        errors = format_errors(changeset)
        error_msg = Enum.at(Map.keys(errors), 0) |> then(fn k -> errors[k] |> Enum.at(0) end)

        socket =
          socket
          |> put_flash(:error, error_msg || "Something went wrong")
          |> assign(form: to_form(params))

        {:noreply, socket}
    end
  end

  defp format_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
