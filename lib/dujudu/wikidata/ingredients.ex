defmodule Dujudu.Wikidata.Ingredients do
  alias Dujudu.Schemas.Ingredient
  alias Dujudu.Wikidata.Client

  def fetch_ingredients do
    with {:ok, ingredients} <- Client.get_ingredients() do
      Enum.map(ingredients, &extract_data/1)
    end
  end

  defp extract_data(wikidata_ingredient) do
    %Ingredient{
      title: get_in(wikidata_ingredient, [:itemLabel, :value]),
      wikidata_id: get_in(wikidata_ingredient, [:item, :value]),
      description: get_in(wikidata_ingredient, [:itemDescription, :value]),
      image_url: get_in(wikidata_ingredient, [:imageUrl, :value])
    }
  end
end
