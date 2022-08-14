defmodule DujuduWeb.IngredientIndexLive do
  use DujuduWeb, :live_view

  alias Dujudu.Access.Ingredients
  alias Dujudu.Schemas.Ingredient

  import Flop.Phoenix
  import Dujudu.Wikidata.ImageUrls, only: [resize_wikidata_image: 2]

  on_mount DujuduWeb.Auth.LiveAuth

  def mount(params, _session, socket) do
    socket = assign(socket, :params, params)
    {:ok, fetch_ingredients(socket)}
  end

  def handle_params(params, _uri, socket) do
    case params["page"] do
      nil ->
        {:noreply, socket}

      page ->
        merged_params = Map.merge(socket.assigns.params, %{"page" => page})
        updated_socket = assign(socket, :params, merged_params)

        {:noreply, fetch_ingredients(updated_socket)}
    end
  end

  def handle_event("search", %{"filters" => %{"0" => %{"value" => search}}}, socket) do
    search_params = %{"0" => %{"field" => "title", "op" => "ilike", "value" => search}}
    merged_params = Map.merge(socket.assigns.params, %{"filters" => search_params})

    updated_socket = assign(socket, params: merged_params)
    {:noreply, fetch_ingredients(updated_socket)}
  end

  defp fetch_ingredients(socket) do
    with {:ok, flop} <- Flop.validate(socket.assigns.params, for: Ingredient) do
      {ingredients, meta} = Ingredients.list_ingredients(flop)
      assign(socket, meta: meta, ingredients: ingredients, current_search: get_current_search(meta))
    end
  end

  defp get_current_search(%{flop: %{filters: filters}}) do
    search = Enum.find(filters, fn element -> Map.get(element, :field) == :title end)
    Map.get(search, :value, nil)
  end

  defp get_current_search(_), do: nil
end
