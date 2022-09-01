defmodule Dujudu.Wikidata.CachedClient do
  require Logger

  alias Dujudu.Wikidata.Access.ClientRequests
  alias Dujudu.Wikidata.{Client, ClientRequest}
  alias Dujudu.Repo

  import Ecto.Query, only: [from: 2]

  @responses_cache_dir Application.fetch_env!(:dujudu, :wikidata_request_cache_directory)
  @keep_log_hours 24

  @spec get_cached() :: {:ok, ClientRequest.t()} | {:error, any()}
  def get_cached() do
    case ClientRequests.get_cached() do
      nil -> fetch_new_request()
      client_request -> {:ok, client_request}
    end
  end

  @spec fetch_new_request(boolean()) :: {:ok, ClientRequest.t()} | {:error, any()}
  defp fetch_new_request(retry \\ true) do
    with {:ok, response} <- Client.get_ingredients(),
      {:ok, request} <- save_request_data((response)) do
        {:ok, request}
    else
      {:error, :wikidata_client_timeout} ->
        Logger.info("wikidata client timeout")
        if retry do
          Logger.info("retrying...")
          fetch_new_request(false)
        else
          {:error, :timeout}
        end

      {:error, reason} -> {:error, reason}
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
