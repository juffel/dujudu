defmodule Dujudu.Wikidata.Images do
  alias Dujudu.Schemas.{Image, Ingredient}
  alias Dujudu.Wikidata.Client

  def fetch_images(%Ingredient{id: ingredient_id, wikidata_id: wikidata_id}) do
    with {:ok, images} <- Client.get_ingredient_images(wikidata_id) do
      Enum.map(images, fn image ->
        build_image(image, ingredient_id)
      end)
    end
  end

  defp build_image(wikidata_image, ingredient_id) do
    %Image{
      commons_url: get_in(wikidata_image, [:image, :value]),
      ingredient_id: ingredient_id
    }
  end
end
