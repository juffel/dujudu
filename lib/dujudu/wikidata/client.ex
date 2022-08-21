defmodule Dujudu.Wikidata.Client do
  use Tesla

  @ingredients_query_path "lib/dujudu/wikidata/queries/ingredients.sparql"
  @ingredient_images_query_path "lib/dujudu/wikidata/queries/ingredient_images.sparql.heex"

  plug Tesla.Middleware.BaseUrl, "https://query.wikidata.org"
  plug Tesla.Middleware.Headers, [{"accept", "application/sparql-results+json"}]
  plug Dujudu.Wikidata.SaveClientResponse

  def get_ingredients do
    @ingredients_query_path
    |> File.read!()
    |> get_response()
  end

  def get_ingredient_images(wikidata_id) do
    @ingredient_images_query_path
    |> File.read!()
    |> EEx.eval_string(assigns: [wikidata_id: wikidata_id])
    |> get_response()
  end

  defp get_response(query) do
    with {:ok, response} <- get("/sparql", query: [query: query]) do
      {:ok, response.body}
    else
      {:error, :timeout} ->
        {:error, :wikidata_client_timeout}

      error ->
        {:error, :wikidata_client_error, error}
    end
  end
end
