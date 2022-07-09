defmodule DujuduWeb.FavController do
  use DujuduWeb, :controller

  alias Dujudu.Access.{Favs, Ingredients}
  alias Dujudu.Schemas.Ingredient

  def index(conn, params) do
    account = conn.assigns[:current_account]

    with {:ok, flop} <- Flop.validate(params, for: Ingredient) do
      {ingredients, meta} = Ingredients.list_fav_ingredients(flop, account.id)

      render(conn, "index.html",
        meta: meta,
        ingredients: ingredients,
        page_title: "Favourites"
      )
    end
  end

  def create(conn, %{"id" => ingredient_id}) do
    account = conn.assigns[:current_account]

    case Favs.create(account.id, ingredient_id) do
      {:ok, _} ->
        conn
        |> redirect(to: Routes.ingredient_path(conn, :show, ingredient_id))

      {:error, _changeset} ->
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
        |> redirect(to: Routes.ingredient_path(conn, :show, ingredient_id))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Something went wrong.")
        |> redirect(to: Routes.ingredient_path(conn, :show, ingredient_id))
    end
  end
end
