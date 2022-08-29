defmodule DujuduWeb.SimilarIngredientIndexLive do
  use DujuduWeb, :live_view

  alias Dujudu.Access.Ingredients
  alias Dujudu.Schemas.Ingredient

  import Dujudu.Wikidata.ImageUrls, only: [resize_wikidata_image: 2]

  on_mount DujuduWeb.Auth.LiveAuth

  def mount(%{"id" => ingredient_id}, _session, socket) do
    ingredient = Ingredients.get_ingredient(ingredient_id)

    {:ok, assign(socket, ingredient: ingredient)}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, fetch_instances(socket, params)}
  end

  defp fetch_instances(socket, params) do
    with {:ok, flop} <- Flop.validate(params, for: Ingredient) do
      {ingredients, meta} =
        socket.assigns.ingredient
        |> Ingredients.get_instances_query()
        |> Ingredients.list_ingredients(flop)

      assign(socket, meta: meta, instances: ingredients)
    end
  end
end
