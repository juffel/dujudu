defmodule DujuduWeb.IngredientView do
  use DujuduWeb, :view

  import Flop.Phoenix
  import Dujudu.Wikidata.ImageUrls, only: [resize_wikidata_image: 2]

  @wikidata_base_url "https://www.wikidata.org/wiki"

  def image_for(ingredient) do
    ingredient.images |> List.first()
  end

  def wikidata_url(%{wikidata_id: id}) do
    Path.join(@wikidata_base_url, id)
  end
end
