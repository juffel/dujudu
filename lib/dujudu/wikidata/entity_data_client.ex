defmodule Dujudu.Wikidata.EntityDataClient do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://www.wikidata.org/wiki/Special:EntityData"
  plug Tesla.Middleware.Headers, [{"accept", "application/sparql-results+json"}]
  plug Tesla.Middleware.JSON

  def get_data(wikidata_id) do
    with {:ok, response} <- get(wikidata_id <> ".json") do
      {:ok, response.body}
    else
      {:error, :timeout} ->
        {:error, :wikidata_client_timeout}

      error ->
        {:error, :wikidata_client_error, error}
    end
  end
end
