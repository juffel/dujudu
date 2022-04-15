defmodule Dujudu.Wikidata.Client do
  use Tesla

  @ingredients_query File.read!("lib/dujudu/wikidata/ingredients.sparql")

  plug Tesla.Middleware.BaseUrl, "https://query.wikidata.org"
  plug Tesla.Middleware.Headers, [{"accept", "application/sparql-results+json"}]
  plug Tesla.Middleware.JSON

  def get_ingredients do
    {:ok, response} = get("/sparql", query: [query: @ingredients_query])

    # Tesla.Middleware.JSON is not doing its job, so calling Jason decode manually here
    ingredients = Jason.decode(response.body)
  end
end
