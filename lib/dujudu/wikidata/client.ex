defmodule Dujudu.Wikidata.Client do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://query.wikidata.org/"

  @ingredients_query File.read!("lib/dujudu/wikidata/ingredients.sparql")

  def get_ingredients do
    {:ok, result} = get("/sparql", query: [query: @ingredients_query])
  end
end
