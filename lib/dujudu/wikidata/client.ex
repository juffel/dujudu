defmodule Dujudu.Wikidata.Client do
  use Tesla

  @ingredients File.read!("lib/dujudu/wikidata/queries/ingredients.sparql")
  @ingredient_images File.read!("lib/dujudu/wikidata/queries/ingredient_images.sparql.heex")

  plug Tesla.Middleware.BaseUrl, "https://query.wikidata.org"
  plug Tesla.Middleware.Headers, [{"accept", "application/sparql-results+json"}]

  def get_ingredients do
    get_response(@ingredients)
  end

  def get_ingredient_images(wikidata_id) do
    @ingredient_images
    |> EEx.eval_string(assigns: [wikidata_id: wikidata_id])
    |> get_response()
  end

  defp get_response(query, retry \\ true) do
    with {:ok, response} <- get("/sparql", query: [query: query]) do
      File.write("./ingredients.json", response.body)
      {:ok, unpack_response(response.body)}
    else
      {:error, :timeout} ->
        if (retry) do
          get_response(query, false)
        else
          raise 'wikidata client timeout'
        end
      _ ->
        raise 'wikidata client timeout'
    end
  end

  defp unpack_response(body) do
    body
    |> Jason.decode!(keys: :atoms)
    |> Map.get(:results)
    |> Map.get(:bindings)
  end
end
