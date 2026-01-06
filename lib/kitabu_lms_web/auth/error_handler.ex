defmodule KitabuLmsWeb.Auth.ErrorHandler do
  @moduledoc """
  Error handler for Guardian authentication errors.
  """
  import Plug.Conn
  import Phoenix.Controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    case type do
      :unauthenticated ->
        conn
        |> put_flash(:error, "You must be signed in to access this page.")
        |> redirect(to: "/sign-in")
        |> halt()

      _ ->
        conn
        |> put_flash(:error, "Authentication error. Please try again.")
        |> redirect(to: "/sign-in")
        |> halt()
    end
  end
end
