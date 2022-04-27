defmodule Dujudu.Wikidata.Ingredients do
  alias Dujudu.Wikidata.{Client, Entity}

  @wikidata_id_prefix "http://www.wikidata.org/entity/"

  def fetch_ingredients(retry \\ true) do
    with {:ok, ingredients} <- Client.get_ingredients() do
      Enum.map(ingredients, &extract_data/1)
    else
      {:error, :wikidata_client_timeout} ->
        if retry do
          fetch_ingredients(false)
        else
          []
        end
    end
  end

  defp extract_data(wikidata_ingredient) do
    %Entity{
      title: get_in(wikidata_ingredient, [:itemLabel, :value]),
      wikidata_id: get_in(wikidata_ingredient, [:item, :value]) |> parse_wikidata_id(),
      instance_of_wikidata_id: get_in(wikidata_ingredient, [:instanceOf, :value]) |> parse_wikidata_id(),
      description: get_in(wikidata_ingredient, [:itemDescription, :value]),
      commons_image_url: get_in(wikidata_ingredient, [:imageUrl, :value])
    }
  end

  defp parse_wikidata_id(nil), do: nil
  defp parse_wikidata_id(id_url) do
    id_url
    |> String.replace(@wikidata_id_prefix, "")
  end
end
