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
      title: wikidata_ingredient.itemLabel[:value],
      wikidata_id: wikidata_ingredient.item[:value]
    }
  end
end
