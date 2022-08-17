defmodule DujuduWeb.IngredientLive do
  use DujuduWeb, :live_view

  alias Dujudu.Access.{Favs, Ingredients}
  alias Dujudu.Wikidata.EntityDataClient

  import Dujudu.Wikidata.ImageUrls, only: [resize_wikidata_image: 2]

  on_mount DujuduWeb.Auth.LiveAuth

  def mount(%{"id" => id}, _session, socket) do
    {:ok, fetch_data(id, socket)}
  end

  defp fetch_data(ingredient_id, socket) do
    ingredient = Ingredients.get_ingredient(ingredient_id)
    extra_data = get_extra_data(ingredient.wikidata_id) # TODO: can this be loaded async?
    instance_of_ingredient = ingredient.instance_of
    similar_ingredients = Ingredients.get_similar_ingredients(ingredient, 5)
    ingredients_of_this_kind = Ingredients.get_ingredients_of_this_kind(ingredient, 5)

    socket
    |> assign(
      ingredient: ingredient,
      page_title: ingredient.title,
      instance_of_ingredient: instance_of_ingredient,
      similar_ingredients: similar_ingredients,
      ingredients_of_this_kind: ingredients_of_this_kind,
      extra_data: extra_data
    )
    |> load_fav()
  end

  defp get_extra_data(wikidata_id) do
    {:ok, data} = EntityDataClient.get_data(wikidata_id)
    data
  end

  defp load_fav(socket) do
    case socket.assigns[:current_account] do
      %{id: account_id} ->
        fav = Favs.get(account_id, socket.assigns[:ingredient].id)
        assign(socket, :fav, fav)

      _else ->
        socket
    end
  end

  def handle_event("add-fav", _value, socket) do
    account = socket.assigns[:current_account]
    %{id: ingredient_id} = socket.assigns[:ingredient]

    case Favs.create(account.id, ingredient_id) do
      {:ok, _} -> {:noreply, load_fav(socket)}
      {:error, _changeset} -> {:noreply, socket}
    end
  end

  def handle_event("remove-fav", _value, socket) do
    account = socket.assigns[:current_account]
    %{id: ingredient_id} = socket.assigns[:ingredient]

    case Favs.delete(account.id, ingredient_id) do
      {:ok, _} -> {:noreply, load_fav(socket)}
      {:error, _changeset} -> {:noreply, socket}
    end
  end
end
