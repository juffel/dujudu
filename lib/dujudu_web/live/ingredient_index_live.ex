defmodule DujuduWeb.IngredientIndexLive do
  use DujuduWeb, :live_view

  alias Dujudu.Access.Ingredients
  alias Dujudu.Schemas.Ingredient

  import Flop.Phoenix
  import Dujudu.Wikidata.ImageUrls, only: [resize_wikidata_image: 2]

  on_mount DujuduWeb.Auth.LiveAuth

  def mount(params, _session, socket) do
    # keep params in socket, in order to access them within handle_event
    updated_socket = assign(socket, current_params: params)
    {:ok, updated_socket}
  end

  def handle_params(params, _uri, socket) do
    # keep params in socket, in order to access them within handle_event
    updated_socket = assign(socket, current_params: params)
    {:noreply, fetch_ingredients(updated_socket, params)}
  end

  def handle_event("search", %{"filters" => %{"0" => %{"value" => search}}}, socket) do
    search_params = %{"0" => %{"field" => "title_or_wid", "op" => "ilike", "value" => search}}
    merged_params = Map.merge(socket.assigns.current_params, %{"filters" => search_params})

    to_path = Routes.live_path(socket, DujuduWeb.IngredientIndexLive, merged_params)
    {:noreply, push_patch(socket, to: to_path)}
  end

  defp fetch_ingredients(socket, params) do
    with {:ok, flop} <- Flop.validate(params, for: Ingredient) do
      {ingredients, meta} = Ingredients.list_ingredients(flop)
      search = get_current_search(meta)
      assign(socket, meta: meta, ingredients: ingredients, current_search: search)
    end
  end

  defp get_current_search(%{flop: %{filters: filters}}) do
    search = Enum.find(filters, fn element -> Map.get(element, :field) == :title_or_wid end)
    Map.get(search || %{}, :value, "")
  end
end
