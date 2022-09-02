defmodule Dujudu.Wikidata.CachedClientTest do
  use DujuduWeb.ConnCase

  alias Dujudu.Repo
  alias Dujudu.Wikidata.ClientRequest

  import Dujudu.Wikidata.CachedClient, only: [get_cached: 0]

  @ingredients_query File.read!("lib/dujudu/wikidata/queries/ingredients.sparql")
  @hours_ago_23 DateTime.utc_now() |> DateTime.add(-60 * 60 * 23, :second)
  @hours_ago_25 DateTime.utc_now() |> DateTime.add(-60 * 60 * 25, :second)
  @cache_directory Application.fetch_env!(:dujudu, :wikidata_request_cache_directory)

  setup do
    # remove test artifacts
    on_exit(fn -> File.rm_rf(@cache_directory) end)
  end

  describe "get_cached/0" do
    setup :mock_request

    test "stores a record of the latest request" do
      refute Repo.one(ClientRequest)
      {:ok, client_request} = get_cached()

      assert [client_request] == Repo.all(ClientRequest)

      assert client_request.query == "QUERY-FOO"
      assert File.read!(client_request.file_path) == "BAROO-DY"
    end
  end

  describe "get_cached/0 when there's a recent cached request" do
    test "returns data from recent request" do
      recent_request = insert(:wikidata_client_request, inserted_at: @hours_ago_23)
      {:ok, request} = get_cached()

      assert recent_request.id == request.id
    end
  end

  describe "get_cached/0 when there's an outdated cached request" do
    setup :mock_request

    test "removes outdated record and creates a new one" do
      old_file_path = Path.join(@cache_directory, "old.json")
      File.write(old_file_path, "{'foo': 'bar'}")

      outdated_request =
        insert(:wikidata_client_request, inserted_at: @hours_ago_25, file_path: old_file_path)

      {:ok, new_request} = get_cached()

      refute new_request.id == outdated_request.id
      refute File.exists?(old_file_path)
      assert is_nil(Repo.reload(outdated_request))
    end
  end

  defp mock_request(_) do
    Tesla.Mock.mock(fn %{method: :get, query: [query: @ingredients_query]} ->
      %Tesla.Env{
        status: 200,
        query: [query: "QUERY-FOO"],
        body: "BAROO-DY"
      }
    end)

    :ok
  end
end
