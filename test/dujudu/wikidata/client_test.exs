defmodule Dujudu.Wikidata.ClientTest do
  use DujuduWeb.ConnCase

  import Dujudu.Wikidata.Client, only: [get_ingredients: 0, get_ingredient_images: 1]

  alias Dujudu.Wikidata.ClientRequest
  alias Dujudu.Repo

  @ingredients_query File.read!("lib/dujudu/wikidata/queries/ingredients.sparql")
  @sample_response File.read!("test/dujudu/wikidata/sample_ingredients.json")

  describe "get_ingredients/0" do
    setup do
      Tesla.Mock.mock(fn %{
                           method: :get,
                           url: "https://query.wikidata.org/sparql",
                           headers: [{"accept", "application/sparql-results+json"}],
                           query: [query: @ingredients_query]
                         } ->
        %Tesla.Env{
          status: 200,
          query: [query: @ingredients_query],
          body: @sample_response
        }
      end)

      :ok
    end

    test "retrieves the current list of ingredients" do
      assert {:ok, @sample_response} = get_ingredients()
    end

    test "stores a record of the latest request" do
      assert Repo.all(ClientRequest) == []
      get_ingredients()
      [request] = Repo.all(ClientRequest)
      assert request.query == @ingredients_query
      assert request.response_body == @sample_response
    end

    @hours_ago_25 DateTime.utc_now() |> DateTime.add(-60 * 60 * 25, :second)
    @hours_ago_23 DateTime.utc_now() |> DateTime.add(-60 * 60 * 23, :second)

    test "removes outdated records and keeps newer ones" do
      outdated_record = insert(:wikidata_client_request, inserted_at: @hours_ago_25)
      recent_record = insert(:wikidata_client_request, inserted_at: @hours_ago_23)

      get_ingredients()

      logged_requests = Repo.all(ClientRequest)
      refute outdated_record in logged_requests
      assert recent_record in logged_requests
    end
  end

  describe "get_ingredients/0 when timeout error occurs" do
    test "returns timeout error on timeout" do
      Tesla.Mock.mock(fn %{method: :get} -> {:error, :timeout} end)

      assert {:error, :wikidata_client_timeout} == get_ingredients()
    end

    test "returns general error when other error occurs" do
      Tesla.Mock.mock(fn %{method: :get} -> {:error, :something_else} end)
      assert {:error, :wikidata_client_error, {:error, :something_else}} == get_ingredients()
    end
  end
end
