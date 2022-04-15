defmodule Dujudu.Wikidata.Client do
  use Tesla

  @ingredients_query File.read!("lib/dujudu/wikidata/ingredients.sparql")

  plug Tesla.Middleware.BaseUrl, "https://query.wikidata.org"
  plug Tesla.Middleware.Headers, [{"accept", "application/sparql-results+json"}]

  def get_ingredients do
    {:ok, response} = get("/sparql", query: [query: @ingredients_query])

    response.body
    |> Jason.decode!(keys: :atoms)
    |> Map.get(:results)
    |> Map.get(:bindings)
    |> Enum.map(fn element -> struct(Dujudu.Wikidata.Ingredient, element) end)
  end
end
