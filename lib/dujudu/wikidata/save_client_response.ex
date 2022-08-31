defmodule Dujudu.Wikidata.SaveClientResponse do
  @behaviour Tesla.Middleware

  alias Dujudu.Wikidata.ClientRequest
  alias Dujudu.Repo

  import Ecto.Query, only: [from: 2]

  @keep_log_hours 24

  @impl Tesla.Middleware
  def call(env, next, _options) do
    case Tesla.run(env, next) do
      {:ok, env} ->
        save_request_data(env)
        {:ok, env}

      result ->
        result
    end
  end

  defp save_request_data(%{query: [query: query], body: body}) do
    with file_name <- file_name_for_query(query),
      file_path <- "./tmp/wikidata_client_cache/#{file_name}.json",
      :ok <- File.write(file_path, body) do

      %{query: query, file_path: file_path}
      |> ClientRequest.create_changeset()
      |> Repo.insert()
    end

    cleanup_old_requests()
  end

  defp save_request_data(_), do: nil

  defp file_name_for_query(query) do
    :crypto.hash(:md5, query) |> Base.encode16()
  end

  defp cleanup_old_requests() do
    hours_ago = hours_ago(@keep_log_hours)

    from(wcr in ClientRequest, where: wcr.inserted_at < ^hours_ago)
    |> Enum.each(fn cr -> File.rm(cr.file_path) end)
    |> Repo.delete_all()
  end

  defp hours_ago(hours) do
    DateTime.utc_now()
    |> DateTime.add(-(hours * 60 * 60), :second)
  end
end
