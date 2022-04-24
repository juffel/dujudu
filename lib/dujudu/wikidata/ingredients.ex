defmodule Dujudu.Wikidata.Ingredients do
  alias Dujudu.Schemas.Ingredient
  alias Dujudu.Wikidata.Client

  @wikidata_id_prefix "http://www.wikidata.org/entity/"

  def fetch_ingredients do
    with {:ok, ingredients} <- Client.get_ingredients() do
      Enum.map(ingredients, &extract_data/1)
    end
  end

  defp extract_data(wikidata_ingredient) do
    %Ingredient{
      title: get_in(wikidata_ingredient, [:itemLabel, :value]),
      wikidata_id: get_in(wikidata_ingredient, [:item, :value]) |> parse_wikidata_id(),
      description: get_in(wikidata_ingredient, [:itemDescription, :value])
    }
  end

  defp parse_wikidata_id(id_url) do
    id_url
    |> String.replace(@wikidata_id_prefix, "")
  end
end
