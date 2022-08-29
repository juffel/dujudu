defmodule Dujudu.Wikidata.Ingredients do
  alias Dujudu.Wikidata.{Client, Entity}
  alias Dujudu.Wikidata.Access.ClientRequests

  @wikidata_id_prefix "http://www.wikidata.org/entity/"

  def fetch_cached_ingredients() do
    fetch_cached_json()
    |> unpack_response()
    |> Enum.group_by(&get_wid/1)
    |> Enum.map(&merge_rows/1)
  end

  defp get_wid(element) do
    get_in(element, [:item, :value]) |> parse_wikidata_id()
  end

  defp fetch_cached_json() do
    with %{response_body: response_body} <- ClientRequests.get_cached() do
      response_body
    else
      _ -> fetch_ingredients()
    end
  end

  defp fetch_ingredients(retry \\ true) do
    with {:ok, ingredients} <- Client.get_ingredients() do
      ingredients
    else
      {:error, :wikidata_client_timeout} ->
        if retry do
          fetch_ingredients(false)
        else
          []
        end
    end
  end

  defp unpack_response(body) do
    body
    |> Jason.decode!(keys: :atoms)
    |> Map.get(:results)
    |> Map.get(:bindings)
  end

  defp merge_rows({_wid, ingredient_rows}) do
    ingredient_rows
    |> Enum.reduce(%Entity{}, fn row, acc ->
      %Entity{
        title: acc.title || get_in(row, [:itemLabel, :value]),
        wikidata_id: acc.wikidata_id || get_in(row, [:item, :value]) |> parse_wikidata_id(),
        description: acc.description || get_in(row, [:itemDescription, :value]),
        instance_of_wikidata_ids: append(acc.instance_of_wikidata_ids, get_in(row, [:instanceOf, :value]) |> parse_wikidata_id()),
        subclass_of_wikidata_ids: append(acc.subclass_of_wikidata_ids, get_in(row, [:subclassOf, :value]) |> parse_wikidata_id()),
        commons_image_urls: append(acc.commons_image_urls, get_in(row, [:imageUrl, :value]))
      }
    end)
  end

  defp append(set, nil), do: set
  defp append(set, value) do
    MapSet.put(set, value)
  end

  defp parse_wikidata_id(nil), do: nil

  defp parse_wikidata_id(id_url) do
    id_url
    |> String.replace(@wikidata_id_prefix, "")
  end
end
