defmodule DujuduWeb.FavController do
  use DujuduWeb, :controller

  alias Dujudu.Access.Favs

  def index(conn, params) do
    account = conn.assigns[:current_account]

    ingredients = Favs.list(account.id)
    render(conn, "index.html", ingredients: ingredients)
  end

  def create(conn, %{"id" => ingredient_id}) do
    account = conn.assigns[:current_account]

    case Favs.create(account.id, ingredient_id) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Fav'd <3")
        |> redirect(to: Routes.ingredient_path(conn, :show, ingredient_id))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Something went wrong.")
        |> redirect(to: Routes.ingredient_path(conn, :show, ingredient_id))
    end
  end

  def delete(conn, %{"id" => ingredient_id}) do
    account = conn.assigns[:current_account]

    case Favs.delete(account.id, ingredient_id) do
      {:ok, _fav} ->
        conn
        |> put_flash(:info, "Unfav'd 😢")
        |> redirect(to: Routes.ingredient_path(conn, :show, ingredient_id))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Something went wrong.")
        |> redirect(to: Routes.ingredient_path(conn, :show, ingredient_id))
    end
  end
end
