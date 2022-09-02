defmodule Dujudu.Wikidata.Client do
  use Tesla

  @ingredients_query_path "lib/dujudu/wikidata/queries/ingredients.sparql"

  plug Tesla.Middleware.BaseUrl, "https://query.wikidata.org"
  plug Tesla.Middleware.Headers, [{"accept", "application/sparql-results+json"}]

  unless Mix.env() == :test, do: plug(Tesla.Middleware.Timeout, timeout: 10_000)

  def get_ingredients do
    @ingredients_query_path
    |> File.read!()
    |> do_get_ingredients()
  end

  defp do_get_ingredients(query) do
    case get("/sparql", query: [query: query]) do
      {:ok, response} ->
        {:ok, response}

      {:error, :timeout} ->
        {:error, :wikidata_client_timeout}

      {:error, error} ->
        {:error, :wikidata_client_error, error}
    end
  end
end
