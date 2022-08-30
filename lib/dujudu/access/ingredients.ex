defmodule Dujudu.Access.Ingredients do
  alias Dujudu.Repo
  alias Dujudu.Schemas.{Fav, Ingredient}
  alias Dujudu.Wikidata.Ingredients

  import Ecto.Query, only: [from: 2]

  def get_ingredient(id) do
    query =
      from i in Ingredient,
        where: i.id == ^id,
        preload: [:images]

    Repo.one(query)
  end

  def get_ingredient_by_wid(wikidata_id) do
    query =
      from i in Ingredient,
        where: i.wikidata_id == ^wikidata_id,
        preload: [:images]

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
        where: i.wikidata_id in ^wids and i.id != ^id,
        preload: [:images]

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
      limit: ^limit,
      preload: [:images]
  end

  def list_ingredients(flop) do
    query = from i in Ingredient, preload: [:images]

    list_ingredients(query, flop)
  end

  def list_ingredients(query, flop) do
    Flop.run(query, flop, for: Ingredient)
  end

  def list_fav_ingredients(flop, account_id) do
    query =
      from i in Ingredient,
        right_join: f in Fav,
        on: [ingredient_id: i.id],
        where: f.account_id == ^account_id,
        preload: [:images]

    Flop.run(query, flop, for: Ingredient)
  end

  def update_ingredients() do
    ingredients =
      Ingredients.fetch_cached_ingredients()
      |> Enum.map(fn entity -> ingest_entity(entity) end)

    Repo.insert_all(
      Ingredient,
      ingredients,
      placeholders: %{timestamp: timestamp()},
      conflict_target: :wikidata_id,
      on_conflict: {:replace_all_except, [:id, :wikidata_id, :created_at]}
    )
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

  defp timestamp() do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.truncate(:second)
  end
end
