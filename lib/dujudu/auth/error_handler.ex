defmodule Dujudu.Auth.ErrorHandler do
  alias DujuduWeb.Router.Helpers, as: Routes

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, _error, _opts) do
    conn
    |> Dujudu.Auth.Guardian.Plug.sign_out()
    |> Phoenix.Controller.put_flash(:error, "Sign in error")
    |> Phoenix.Controller.redirect(to: Routes.live_path(conn, DujuduWeb.HomeLive))
  end
end
