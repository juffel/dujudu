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
      {:ok, _account} ->
        conn
        |> put_flash(:info, "Account created!")
        |> redirect(to: Routes.ingredient_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
     end
  end
end