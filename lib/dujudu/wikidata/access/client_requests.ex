defmodule Dujudu.Wikidata.Access.ClientRequests do
  alias Dujudu.Wikidata.ClientRequest
  alias Dujudu.Repo

  import Ecto.Query, only: [from: 2]

  @ingredient_cache_hours 24

  def get_cached() do
    timestamp_threshold =
      DateTime.utc_now()
      |> DateTime.add(-@ingredient_cache_hours * 3600, :second)

    query =
      from cr in ClientRequest,
      order_by: [desc: cr.inserted_at],
      where: cr.inserted_at > ^timestamp_threshold,
      limit: 1

    Repo.one(query)
  end
end