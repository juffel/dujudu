defmodule DujuduWeb.AccountController do
  use DujuduWeb, :controller

  alias Dujudu.Schemas.Account
  alias Dujudu.Access.Accounts

  def new(conn, _params) do
    changeset = Account.create_changeset(%{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"account" => params}) do
    case Accounts.create(params) do
      {:ok, account} ->
        conn
        |> Dujudu.Auth.Guardian.Plug.sign_in(account)
        |> put_flash(:info, "Account created")
        |> redirect(to: Routes.live_path(conn, DujuduWeb.HomeLive))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
