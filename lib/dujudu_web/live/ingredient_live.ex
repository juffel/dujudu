defmodule DujuduWeb.IngredientLive do
  use DujuduWeb, :live_view

  alias Dujudu.Access.{Favs, Ingredients}

  import Dujudu.Wikidata.ImageUrls, only: [resize_wikidata_image: 2]

  def mount(%{"id" => id}, _dunno, socket) do
    {:ok, fetch_data(id, socket)}
  end

  defp fetch_data(ingredient_id, socket) do
    ingredient = Ingredients.get_ingredient(ingredient_id)
    instance_of_ingredient = ingredient.instance_of
    similar_ingredients = Ingredients.get_similar_ingredients(ingredient, 5)
    ingredients_of_this_kind = Ingredients.get_ingredients_of_this_kind(ingredient, 5)

    socket
    |> assign(
      ingredient: ingredient,
      page_title: ingredient.title,
      instance_of_ingredient: instance_of_ingredient,
      similar_ingredients: similar_ingredients,
      ingredients_of_this_kind: ingredients_of_this_kind
    )
  end

  def handle_event("add-fav", _value, socket) do
    account = socket.assigns[:current_account]
    %{id: ingredient_id} = socket.assigns[:ingredient]

    case Favs.create(account.id, ingredient_id) do
      {:ok, _} ->
        refreshed_ingredient = Ingredients.get_ingredient(ingredient_id)
        {:noreply, assign(socket, :ingredient, refreshed_ingredient)}

      {:error, _changeset} ->
        # conn
        # |> put_flash(:error, "Something went wrong.")
        # |> redirect(to: Routes.ingredient_path(conn, :show, ingredient_id))
    end
  end
end
