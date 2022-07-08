defmodule DujuduWeb.ImageHelpers do
  @wikidata_base_url "https://www.wikidata.org/wiki"

  def image_for(ingredient) do
    ingredient.images |> List.first()
  end

  def wikidata_url(%{wikidata_id: id}) do
    Path.join(@wikidata_base_url, id)
  end
end
