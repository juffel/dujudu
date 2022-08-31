defmodule Dujudu.Wikidata.Ingredients do
  alias Dujudu.Wikidata.Entity

  @wikidata_id_prefix "http://www.wikidata.org/entity/"

  def ingredient_data_from_rows(entities) do
    entities
    |> Enum.group_by(&get_wikidata_id/1)
    |> Enum.map(&merge_rows/1)
    |> Enum.map(fn entity -> ingest_entity(entity) end)
  end

  defp get_wikidata_id(element) do
    get_in(element, [:itemId, :value]) |> parse_wikidata_id()
  end

  defp merge_rows({_wid, ingredient_rows}) do
    ingredient_rows
    |> Enum.reduce(%Entity{}, fn row, acc ->
      %Entity{
        title: acc.title || get_in(row, ["itemLabel", "value"]),
        wikidata_id: acc.wikidata_id || get_in(row, ["item", "value"]) |> parse_wikidata_id(),
        description: acc.description || get_in(row, ["itemDescription", "value"]),
        instance_of_wikidata_ids:
          append(
            acc.instance_of_wikidata_ids,
            get_in(row, ["instanceOf", "value"]) |> parse_wikidata_id()
          ),
        subclass_of_wikidata_ids:
          append(
            acc.subclass_of_wikidata_ids,
            get_in(row, ["subclassOf", "value"]) |> parse_wikidata_id()
          ),
        commons_image_urls: append(acc.commons_image_urls, get_in(row, ["imageUrl", "value"]))
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

  defp ingest_entity(%{
         title: title,
         wikidata_id: wikidata_id,
         description: description,
         instance_of_wikidata_ids: instance_of_wikidata_ids,
         subclass_of_wikidata_ids: subclass_of_wikidata_ids,
         commons_image_urls: commons_image_urls
       }) do
    %{
      title: title,
      wikidata_id: wikidata_id,
      description: description,
      instance_of_wikidata_ids: MapSet.to_list(instance_of_wikidata_ids),
      subclass_of_wikidata_ids: MapSet.to_list(subclass_of_wikidata_ids),
      commons_image_urls: MapSet.to_list(commons_image_urls),
      inserted_at: {:placeholder, :timestamp},
      updated_at: {:placeholder, :timestamp}
    }
  end

end
