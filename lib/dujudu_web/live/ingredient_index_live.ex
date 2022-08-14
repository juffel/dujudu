defmodule DujuduWeb.IngredientIndexLive do
  use DujuduWeb, :live_view

  alias Dujudu.Access.Ingredients
  alias Dujudu.Schemas.Ingredient

  import Flop.Phoenix
  import Dujudu.Wikidata.ImageUrls, only: [resize_wikidata_image: 2]

  on_mount DujuduWeb.Auth.LiveAuth

  def mount(%{"filters" => %{"0" => %{"value" => search}}}, _session, socket) do
    {:ok, fetch_ingredients(search, socket)}
  end

  def mount(_params, _session, socket) do
    {:ok, fetch_ingredients(nil, socket)}
  end

  defp fetch_ingredients(search, socket) do
    params = %{
      "filters" => %{
        "0" => %{"field" => "title", "op" => "=~", "value" => search}
      }
    }

    with {:ok, flop} <- Flop.validate(params, for: Ingredient) do
      {ingredients, meta} = Ingredients.list_ingredients(flop)
      assign(socket, meta: meta, ingredients: ingredients)
    end
  end

  def handle_event("search", %{"filters" => %{"0" => %{"value" => search}}}, socket) do
    {:noreply, fetch_ingredients(search, socket)}
  end
end
