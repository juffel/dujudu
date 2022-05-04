defmodule Dujudu.Wikidata.Client do
  use Tesla

  @ingredients File.read!("lib/dujudu/wikidata/queries/ingredients.sparql")
  @ingredient_images File.read!("lib/dujudu/wikidata/queries/ingredient_images.sparql.heex")

  plug Tesla.Middleware.BaseUrl, "https://query.wikidata.org"
  plug Tesla.Middleware.Headers, [{"accept", "application/sparql-results+json"}]
  plug Dujudu.Wikidata.SaveClientResponse

  def get_ingredients do
    get_response(@ingredients)
  end

  def get_ingredient_images(wikidata_id) do
    @ingredient_images
    |> EEx.eval_string(assigns: [wikidata_id: wikidata_id])
    |> get_response()
  end

  defp get_response(query) do
    with {:ok, response} <- get("/sparql", query: [query: query]) do
      {:ok, unpack_response(response.body)}
    else
      {:error, :timeout} ->
        {:error, :wikidata_client_timeout}
      error ->
        {:error, :wikidata_client_error, error}
    end
  end

  defp unpack_response(body) do
    body
    |> Jason.decode!(keys: :atoms)
    |> Map.get(:results)
    |> Map.get(:bindings)
  end
end
