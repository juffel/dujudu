defmodule Dujudu.Wikidata.Client do
  use Tesla

  alias Dujudu.Wikidata.ClientRequest
  alias Dujudu.Repo

  import Ecto.Query, only: [from: 2]

  @ingredients_query_path "lib/dujudu/wikidata/queries/ingredients.sparql"
  @keep_log_hours 24

  plug Tesla.Middleware.BaseUrl, "https://query.wikidata.org"
  plug Tesla.Middleware.Headers, [{"accept", "application/sparql-results+json"}]

  @responses_cache_dir "tmp/wikidata_client_cache"

  def get_request do
    @ingredients_query_path
    |> File.read!()
    |> do_get_request()
  end

  defp do_get_request(query) do
    with {:ok, response} <- get("/sparql", query: [query: query]),
      {:ok, client_request} <- save_request_data((response)) do
        {:ok, client_request}

      else
        {:error, :timeout} ->
          {:error, :wikidata_client_timeout}

        {:error, error} ->
          {:error, :wikidata_client_error, error}
    end
  end

  defp save_request_data(%{query: [query: query], body: body}) do
    with file_name <- file_name_for_query(query),
      :ok <- File.mkdir_p(@responses_cache_dir),
      file_path <- Path.join([@responses_cache_dir, "#{file_name}.json"]),
      :ok <- File.write(file_path, body) do

      client_request =
        %{query: query, file_path: file_path}
        |> ClientRequest.create_changeset()
        |> Repo.insert()

      cleanup_old_requests()

      client_request
    end
  end

  defp save_request_data(_), do: {:error, :invalid_response}

  defp file_name_for_query(query) do
    :crypto.hash(:md5, query) |> Base.encode16()
  end

  defp cleanup_old_requests() do
    hours_ago = hours_ago(@keep_log_hours)

    from(cr in ClientRequest, where: cr.inserted_at < ^hours_ago)
    |> Repo.all()
    |> Enum.each(fn cr ->
      File.rm(cr.file_path)
      Repo.delete(cr)
    end)
  end

  defp hours_ago(hours) do
    DateTime.utc_now()
    |> DateTime.add(-(hours * 60 * 60), :second)
  end
end
