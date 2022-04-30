defmodule Dujudu.Wikidata.SaveClientResponse do
  @behaviour Tesla.Middleware

  alias Dujudu.Wikidata.ClientRequest
  alias Dujudu.Repo

  import Ecto.Query, only: [from: 2]

  @keep_log_hours 24

  @impl Tesla.Middleware
  def call(env, next, _options) do
    with {:ok, env} <- Tesla.run(env, next) do
      save_request_data(env)

      {:ok, env}
    else
      result -> result
    end
  end

  defp save_request_data(%{query: [query: query], body: body}) do
    %{query: query, response_body: body}
    |> ClientRequest.create_changeset()
    |> Repo.insert()

    cleanup_old_requests()
  end

  defp save_request_data(_), do: nil

  defp cleanup_old_requests() do
    hours_ago = hours_ago(@keep_log_hours)
    from(wcr in ClientRequest, where: wcr.inserted_at < ^hours_ago)
    |> Repo.delete_all()
  end

  defp hours_ago(hours) do
    DateTime.utc_now()
    |> DateTime.add(-(hours * 60 * 60), :second)
  end
end
