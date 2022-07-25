defmodule DujuduWeb.SessionController do
  use DujuduWeb, :controller

  alias Dujudu.Access.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case authenticate(email, password) do
      {:ok, account} ->
        conn
        |> Dujudu.Auth.Guardian.Plug.sign_in(account)
        |> put_flash(:info, "Logged in successfully")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> render("new.html")
    end
  end

  defp authenticate(email, password) do
    email
    |> Accounts.get_by_email()
    |> Argon2.check_pass(password)
  end

  def delete(conn, _params) do
    conn
    |> Dujudu.Auth.Guardian.Plug.sign_out()
    |> put_flash(:info, "Logged out successfully")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
