defmodule DujuduWeb.SimilarIngredientIndexLive do
  use DujuduWeb, :live_view

  alias Dujudu.Access.Ingredients
  alias Dujudu.Schemas.Ingredient

  import Dujudu.Wikidata.ImageUrls, only: [resize_wikidata_image: 2]

  on_mount DujuduWeb.Auth.LiveAuth

  def mount(%{"id" => ingredient_id}, _session, socket) do
    %{instance_of_wikidata_id: wid} = Ingredients.get_ingredient(ingredient_id) |> IO.inspect()
    ingredient = Ingredients.get_ingredient_by_wid(wid)
    {:ok, assign(socket, ingredient: ingredient, wikidata_id: wid)}
  end

  def handle_params(params, _uri, socket) do
    search_params = %{"0" => %{"field" => "instance_of_wikidata_id", "op" => "==", "value" => socket.assigns.wikidata_id}}
    merged_params = Map.merge(params, %{"filters" => search_params})

    {:noreply, fetch_similar_ingredients(socket, merged_params)}
  end

  defp fetch_similar_ingredients(socket, params) do
    with {:ok, flop} <- Flop.validate(params, for: Ingredient) do
      {ingredients, meta} = Ingredients.list_ingredients(flop)
      assign(socket, meta: meta, ingredients: ingredients)
    end
  end
end
