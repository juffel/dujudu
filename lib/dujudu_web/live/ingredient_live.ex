defmodule DujuduWeb.IngredientLive do
  use DujuduWeb, :live_view

  alias Dujudu.Access.{Favs, Ingredients}

  import Dujudu.Wikidata.ImageUrls, only: [resize_wikidata_image: 2]

  on_mount DujuduWeb.Auth.LiveAuth

  def mount(%{"id" => id}, _session, socket) do
    case Ingredients.get_ingredient(id) do
      nil ->
        {:ok, redirect(socket, to: Routes.live_path(socket, DujuduWeb.IngredientIndexLive))}

      ingredient ->
        {:ok, fetch_data(ingredient, socket)}
    end
  end

  defp fetch_data(ingredient, socket) do
    supers = Ingredients.get_supers(ingredient)
    instances = Ingredients.get_instances(ingredient)
    instances_count = length(instances)

    socket
    |> assign(
      ingredient: ingredient,
      page_title: ingredient.title,
      supers: supers,
      instances: Enum.take(instances, 5),
      instances_count: instances_count
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
