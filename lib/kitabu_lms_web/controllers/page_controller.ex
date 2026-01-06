defmodule KitabuLmsWeb.PageController do
  use KitabuLmsWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
