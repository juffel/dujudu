defmodule DujuduWeb.ImageHelpers do
  @wikidata_base_url "https://www.wikidata.org/wiki"
  @blank_image_path "/images/1x1-00000000.png"

  def image_url_for(ingredient) do
    ingredient.commons_image_urls |> List.first()
  end

  def wikidata_url(%{wikidata_id: id}) do
    Path.join(@wikidata_base_url, id)
  end

  def blank_image_url(socket) do
    DujuduWeb.Router.Helpers.static_path(socket, @blank_image_path)
  end
end
