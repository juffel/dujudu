defmodule Dujudu.Wikidata.Client do
  use Tesla

  @ingredients_query_path "lib/dujudu/wikidata/queries/ingredients.sparql"
  @timeout_ms Application.fetch_env!(:dujudu, :wikidata_request_timeout_ms)

  plug Tesla.Middleware.BaseUrl, "https://query.wikidata.org"
  plug Tesla.Middleware.Timeout, timeout: @timeout_ms
  plug Tesla.Middleware.Headers, [{"accept", "application/sparql-results+json"}]

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
