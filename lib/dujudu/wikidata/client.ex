defmodule Dujudu.Wikidata.Client do
  use Tesla

  @ingredients_query File.read!("lib/dujudu/wikidata/ingredients.sparql")

  plug Tesla.Middleware.BaseUrl, "https://query.wikidata.org"
  plug Tesla.Middleware.Headers, [{"accept", "application/sparql-results+json"}]

  def get_ingredients do
    with {:ok, response} <- get("/sparql", query: [query: @ingredients_query]) do
      {:ok, unpack_response(response.body)}
    end
  end

  defp unpack_response(body) do
    body
    |> Jason.decode!(keys: :atoms)
    |> Map.get(:results)
    |> Map.get(:bindings)
  end
end
