defmodule Dujudu.Wikidata.Access.IngredientsTest do
  use Dujudu.DataCase

  describe "get_cached/0" do
    import Dujudu.Wikidata.Access.ClientRequests, only: [get_cached: 0]

    test "returns the most recent fresh request" do
      request = insert(:wikidata_client_request, inserted_at: hours_ago(2))
      insert(:wikidata_client_request, inserted_at: hours_ago(23))

      assert request == get_cached()
    end

    test "returns nil if there is no request" do
      refute get_cached()
    end

    test "returns nil if there is only a stale request" do
      insert(:wikidata_client_request, inserted_at: hours_ago(25))
      refute get_cached()
    end

    defp hours_ago(hours) do
      DateTime.utc_now()
      |> DateTime.add(-hours * 3600, :second)
    end
  end
end
