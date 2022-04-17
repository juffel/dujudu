defmodule Dujudu.Access.Ingredients do
  alias Dujudu.Repo
  alias Dujudu.Schemas.Ingredient
  alias Dujudu.Wikidata.Ingredients

  def list_ingredients(flop) do
    Flop.run(Ingredient, flop, for: Ingredient)
  end

  def update_ingredients() do
    Ingredients.fetch_ingredients()
    |> Enum.each(fn ingredient ->
      Repo.insert!(ingredient, conflict_target: :wikidata_id, on_conflict: :replace_all)
    end)
  end
end
