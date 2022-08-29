defmodule Dujudu.Access.Ingredients do
  alias Dujudu.Repo
  alias Dujudu.Schemas.{Fav, Image, Ingredient}
  alias Dujudu.Wikidata.Ingredients

  import Ecto.Query, only: [from: 2]

  def get_ingredient(id) do
    query =
      from i in Ingredient,
        where: i.id == ^id,
        # , :instance_of_wikidata_ids, :subclass_of_wikidata_ids]
        preload: [:images]

    Repo.one(query)
  end

  def get_ingredient_by_wid(wikidata_id) do
    query =
      from i in Ingredient,
        where: i.wikidata_id == ^wikidata_id,
        # , :instance_of_wikidata_ids, :subclass_of_wikidata_ids]
        preload: [:images]

    Repo.one(query)
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
    Ingredients.fetch_cached_ingredients()
    |> Enum.each(fn entity ->
      %{id: ingredient_id} = upsert_ingredient(entity)
      Enum.each(entity.commons_image_urls, fn url -> upsert_image(ingredient_id, url) end)
    end)
  end

  defp upsert_ingredient(entity) do
    entity
    |> ingest_entity()
    |> Repo.insert(
      conflict_target: :wikidata_id,
      on_conflict: {:replace_all_except, [:id, :wikidata_id]}
    )

    # do a fresh load from db, since insert + on_conflict returns a fake/unpersisted id in case the record already exists
    Repo.get_by(Ingredient, wikidata_id: entity.wikidata_id)
  end

  defp ingest_entity(%{
         title: title,
         wikidata_id: wikidata_id,
         description: description,
         instance_of_wikidata_ids: instance_of_wikidata_ids,
         subclass_of_wikidata_ids: subclass_of_wikidata_ids
       }) do
    %Ingredient{
      title: title,
      wikidata_id: wikidata_id,
      description: description,
      instance_of_wikidata_ids: MapSet.to_list(instance_of_wikidata_ids),
      subclass_of_wikidata_ids: MapSet.to_list(subclass_of_wikidata_ids)
    }
  end

  defp upsert_image(ingredient_id, url) do
    %{commons_url: url, ingredient_id: ingredient_id}
    |> Image.create_changeset()
    |> Repo.insert(conflict_target: [:commons_url, :ingredient_id], on_conflict: :nothing)
  end
end
