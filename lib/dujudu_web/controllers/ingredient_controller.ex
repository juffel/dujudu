defmodule DujuduWeb.IngredientController do
  use DujuduWeb, :controller

  alias Dujudu.Access.{Favs, Ingredients}
  alias Dujudu.Schemas.Ingredient

  plug :load_ingredient when action in [:show]
  plug :load_fav when action in [:show]

  def index(conn, params) do
    with {:ok, flop} <- Flop.validate(params, for: Ingredient) do
      {ingredients, meta} = Ingredients.list_ingredients(flop)
      render(conn, "index.html", meta: meta, ingredients: ingredients)
    end
  end

  def show(conn, %{"id" => id}) do
    ingredient = Ingredients.get_ingredient(id)
    instance_of_ingredient = ingredient.instance_of
    similar_ingredients = Ingredients.get_similar_ingredients(ingredient, 5)
    ingredients_of_this_kind = Ingredients.get_ingredients_of_this_kind(ingredient, 5)

    render(conn, "show.html",
      ingredient: ingredient,
      page_title: ingredient.title,
      instance_of_ingredient: instance_of_ingredient,
      similar_ingredients: similar_ingredients,
      ingredients_of_this_kind: ingredients_of_this_kind
    )
  end

  defp load_ingredient(conn, _opts) do
    case Ingredients.get_ingredient(conn.params["id"]) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(DujuduWeb.ErrorView)
        |> render(:"404")

      ingredient ->
        assign(conn, :ingredient, ingredient)
    end
  end

  # fetch fav status if a current account is present
  defp load_fav(conn, _opts) do
    case conn.assigns[:current_account] do
      nil ->
        conn

      account ->
        fav = Favs.get(account.id, conn.assigns[:ingredient].id)
        assign(conn, :fav, fav)
    end
  end
end
