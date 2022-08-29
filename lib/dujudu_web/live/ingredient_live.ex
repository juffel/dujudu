defmodule DujuduWeb.IngredientLive do
  use DujuduWeb, :live_view

  alias Dujudu.Access.{Favs, Ingredients}

  import Dujudu.Wikidata.ImageUrls, only: [resize_wikidata_image: 2]

  on_mount DujuduWeb.Auth.LiveAuth

  def mount(%{"id" => id}, _session, socket) do
    {:ok, fetch_data(id, socket)}
  end

  defp fetch_data(ingredient_id, socket) do
    ingredient = Ingredients.get_ingredient(ingredient_id)
    supers = Ingredients.get_supers(ingredient)
    instances = Ingredients.get_instances(ingredient)

    socket
    |> assign(
      ingredient: ingredient,
      page_title: ingredient.title,
      supers: supers,
      instances: instances
    )
    |> load_fav()
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
