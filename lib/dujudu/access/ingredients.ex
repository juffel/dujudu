defmodule Dujudu.Access.Ingredients do
  alias Dujudu.Repo
  alias Dujudu.Schemas.{Fav, Ingredient}
  alias Dujudu.Wikidata.{CachedClient, StreamResponse}

  import Ecto.Query, only: [from: 2]

  def get_ingredient(id) do
    query =
      from i in Ingredient,
        where: i.id == ^id

    Repo.one(query)
  end

  def get_ingredient_by_wid(wikidata_id) do
    query =
      from i in Ingredient,
        where: i.wikidata_id == ^wikidata_id

    Repo.one(query)
  end

  def sample_ingredients(length, seed) do
    query =
      from i in Ingredient,
        order_by: fragment("md5(wikidata_id || ?)", ^seed),
        where: i.commons_image_urls != fragment("'{}'"),
        limit: ^length

    Repo.all(query)
  end

  def get_supers(%Ingredient{
        id: id,
        instance_of_wikidata_ids: instance_ofs,
        subclass_of_wikidata_ids: subclass_ofs
      }) do
    wids = instance_ofs ++ subclass_ofs

    query =
      from i in Ingredient,
        where: i.wikidata_id in ^wids and i.id != ^id

    Repo.all(query)
  end

  def get_instances(ingredient, limit \\ nil) do
    ingredient
    |> get_instances_query(limit)
    |> Repo.all()
  end

  def get_instances_query(%Ingredient{wikidata_id: wid}, limit \\ nil) do
    from i in Ingredient,
      where: ^wid in i.instance_of_wikidata_ids or ^wid in i.subclass_of_wikidata_ids,
      limit: ^limit
  end

  def list_ingredients(flop) do
    list_ingredients(Ingredient, flop)
  end

  def list_ingredients(query, flop) do
    Flop.run(query, flop, for: Ingredient)
  end

  def list_fav_ingredients(flop, account_id) do
    query =
      from i in Ingredient,
        right_join: f in Fav,
        on: [ingredient_id: i.id],
        where: f.account_id == ^account_id

    Flop.run(query, flop, for: Ingredient)
  end

  def update_ingredients() do
    case CachedClient.get_cached() do
      {:ok, client_request} -> handle_response(client_request)
      {:error, reason} -> {:error, reason}
    end
  end

  defp handle_response(client_request) do
    client_request
    |> StreamResponse.stream_cached_ingredients()
    |> Stream.map(fn ingredient_maps ->
      augmented_maps =
        Enum.map(ingredient_maps, fn ingredient ->
          Map.merge(ingredient, %{
            inserted_at: {:placeholder, :timestamp},
            updated_at: {:placeholder, :timestamp}
          })
        end)

      Repo.insert_all(
        Ingredient,
        augmented_maps,
        placeholders: %{timestamp: DateTime.utc_now()},
        conflict_target: :wikidata_id,
        on_conflict: {:replace_all_except, [:id, :wikidata_id, :inserted_at]}
      )
    end)
    |> Stream.run()
  end
end
