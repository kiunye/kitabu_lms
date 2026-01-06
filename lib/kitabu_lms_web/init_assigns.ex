defmodule KitabuLmsWeb.InitAssigns do
  @moduledoc """
  LiveView mount assigns for authentication state.
  """
  use Phoenix.LiveView

  import Plug.Conn
  import Guardian.Plug

  def on_mount(:default, _params, _session, socket) do
    case current_resource(socket) do
      nil ->
        user_id = get_session(socket, :current_user_id)

        if user_id do
          case KitabuLms.Repo.get(KitabuLms.Accounts.User, user_id) do
            nil ->
              {:cont, socket}

            user ->
              {:cont, assign(socket, current_user: user, current_tenant: user.tenant)}
          end
        else
          {:cont, socket}
        end

      user ->
        {:cont, assign(socket, current_user: user, current_tenant: user.tenant)}
    end
  end

  def on_mount(:auth, _params, _session, socket) do
    case current_resource(socket) do
      nil ->
        {:cont, socket}

      _user ->
        {:halt, redirect(socket, to: "/")}
    end
  end

  def on_mount(:protected, _params, _session, socket) do
    case current_resource(socket) do
      nil ->
        {:halt, redirect(socket, to: "/sign-in")}

      user ->
        {:cont, assign(socket, current_user: user)}
    end
  end
end
