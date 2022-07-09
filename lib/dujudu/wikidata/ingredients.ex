defmodule Dujudu.Wikidata.Ingredients do
  alias Dujudu.Wikidata.{Client, Entity}
  alias Dujudu.Wikidata.Access.ClientRequests

  @wikidata_id_prefix "http://www.wikidata.org/entity/"

  def fetch_cached_ingredients() do
    fetch_cached_json()
    |> unpack_response()
    |> Enum.map(&extract_data/1)
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

  defp extract_data(wikidata_ingredient) do
    %Entity{
      title: get_in(wikidata_ingredient, [:itemLabel, :value]),
      wikidata_id: get_in(wikidata_ingredient, [:item, :value]) |> parse_wikidata_id(),
      instance_of_wikidata_id:
        get_in(wikidata_ingredient, [:instanceOf, :value]) |> parse_wikidata_id(),
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
