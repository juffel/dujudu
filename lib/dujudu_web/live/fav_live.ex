defmodule DujuduWeb.FavLive do
  use DujuduWeb, :live_view

  alias Dujudu.Access.Ingredients
  alias Dujudu.Schemas.Ingredient

  import Dujudu.Wikidata.ImageUrls, only: [resize_wikidata_image: 2]

  on_mount DujuduWeb.Auth.LiveAuth

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Bookmarks")}
  end

  def handle_params(params, _uri, socket) do
    %{id: account_id} = socket.assigns[:current_account]

    with {:ok, flop} <- Flop.validate(params, for: Ingredient) do
      {ingredients, meta} = Ingredients.list_fav_ingredients(flop, account_id)

      {:noreply, assign(socket, meta: meta, ingredients: ingredients, page_title: "Bookmarks")}
    end
  end
end
