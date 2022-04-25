defmodule Dujudu.Access.Ingredients do
  alias Dujudu.Repo
  alias Dujudu.Schemas.Ingredient
  alias Dujudu.Wikidata.Ingredients

  import Ecto.Query, only: [from: 2]
  import Ecto.Query.API, only: [fragment: 1]

  def list_ingredients(flop) do
    Flop.run(Ingredient, flop, for: Ingredient)
  end

  def sample_ingredient() do
    query = from i in Ingredient, order_by: fragment("RANDOM()"), limit: 1
    Repo.one(query)
  end

  def update_ingredients() do
    Ingredients.fetch_ingredients()
    |> Enum.each(fn ingredient ->
      Repo.insert!(ingredient, conflict_target: :wikidata_id, on_conflict: :replace_all)
    end)
  end
end
