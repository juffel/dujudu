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
    instance_of_ingredient = ingredient.instance_of
    similar_ingredients = Ingredients.get_similar_ingredients(ingredient, 5)
    ingredients_of_this_kind = Ingredients.get_ingredients_of_this_kind(ingredient, 5)
    render(conn, "show.html", ingredient: ingredient,
                              instance_of_ingredient: instance_of_ingredient,
                              similar_ingredients: similar_ingredients,
                              ingredients_of_this_kind: ingredients_of_this_kind)
  end
end
