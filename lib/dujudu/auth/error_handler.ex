defmodule Dujudu.Auth.ErrorHandler do
  alias DujuduWeb.Router.Helpers, as: Routes

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, _error, _opts) do
    conn
    |> Dujudu.Auth.Guardian.Plug.sign_out()
    |> Phoenix.Controller.redirect(to: Routes.page_path(conn, :index))
  end
end
