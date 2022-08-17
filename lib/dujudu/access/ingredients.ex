defmodule Dujudu.Access.Ingredients do
  alias Dujudu.Repo
  alias Dujudu.Schemas.{Fav, Image, Ingredient}
  alias Dujudu.Wikidata.Ingredients

  import Ecto.Query, only: [from: 2]

  def get_ingredient(id) do
    query =
      from i in Ingredient,
        where: i.id == ^id,
        preload: [:images, :instance_of]

    Repo.one(query)
  end

  def get_similar_ingredients(%Ingredient{instance_of_wikidata_id: nil}, _limit), do: []

  def get_similar_ingredients(%Ingredient{id: id, instance_of_wikidata_id: wid}, limit) do
    query =
      from i in Ingredient,
        where: i.instance_of_wikidata_id == ^wid and i.id != ^id,
        limit: ^limit,
        order_by: fragment("md5(id || ?)", ^id),
        preload: [:images]

    Repo.all(query)
  end

  def get_ingredients_of_this_kind(%Ingredient{id: id, wikidata_id: wid}, limit) do
    query =
      from i in Ingredient,
        where: i.instance_of_wikidata_id == ^wid,
        limit: ^limit,
        order_by: fragment("md5(id || ?)", ^id),
        preload: [:images]

    Repo.all(query)
  end

  def list_ingredients(flop) do
    query =
      from i in Ingredient,
        preload: [:images]

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

  def sample_ingredient() do
    query =
      from i in Ingredient,
        order_by: fragment("RANDOM()"),
        limit: 1

    Repo.one(query)
  end

  def update_ingredients() do
    Ingredients.fetch_cached_ingredients()
    |> Enum.each(fn entity ->
      upsert_ingredient(entity)
      |> upsert_image(entity)
    end)
  end

  defp upsert_ingredient(entity) do
    struct(Ingredient, Map.from_struct(entity))
    |> Repo.insert(
      conflict_target: :wikidata_id,
      on_conflict: {:replace_all_except, [:id, :wikidata_id]}
    )

    # do a fresh load from db, since insert + on_conflict returns a fake/unpersisted id in case the record already exists
    Repo.get_by(Ingredient, wikidata_id: entity.wikidata_id)
  end

  defp upsert_image(_, %{commons_image_url: nil}), do: nil

  defp upsert_image(%{id: ingredient_id}, %{commons_image_url: url}) do
    %{commons_url: url, ingredient_id: ingredient_id}
    |> Image.create_changeset()
    |> Repo.insert(conflict_target: [:commons_url, :ingredient_id], on_conflict: :nothing)
  end
end
