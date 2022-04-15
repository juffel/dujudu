defmodule Dujudu.Access.Ingredients do
  alias Dujudu.Repo
  alias Dujudu.Schemas.Ingredient

  def list_ingredients(flop) do
    Flop.run(Ingredient, flop, for: Ingredient)
  end

  def update_ingredients(wikidata_ingredients) do
    wikidata_ingredients
    |> Enum.map(fn wikidata_ingredient ->
      %Ingredient{title: wikidata_ingredient.itemLabel[:value],
        wikidata_id: wikidata_ingredient.item[:value],
        unit: :unknown}
    end)
    |> Enum.each(fn ingredient ->
      Repo.insert!(ingredient, conflict_target: :wikidata_id, on_conflict: :replace_all)
    end)
  end
end
