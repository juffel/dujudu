defmodule DujuduWeb.IngredientController do
  use DujuduWeb, :controller

  alias Dujudu.Access.Ingredients
  alias Dujudu.Schemas.Ingredient

  def index(conn, params) do
    with {:ok, flop} <- Flop.validate(params, for: Ingredient) do
      {ingredients, meta} = Ingredients.list_ingredients(flop)
      render(conn, "index.html", meta: meta, ingredients: ingredients)
    end
  end

  def show(conn, %{"id" => id}) do
    ingredient = Ingredients.get_ingredient(id)
    similar_ingredients = Ingredients.get_similar_ingredients(ingredient)
    render(conn, "show.html", ingredient: ingredient, similar_ingredients: similar_ingredients)
  end
end
