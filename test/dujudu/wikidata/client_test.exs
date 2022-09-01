defmodule Dujudu.Wikidata.ClientTest do
  use DujuduWeb.ConnCase

  import Dujudu.Wikidata.Client, only: [get_ingredients: 0]

  @ingredients_query File.read!("lib/dujudu/wikidata/queries/ingredients.sparql")
  @sample_response File.read!("test/dujudu/wikidata/sample_ingredients.json")

  describe "get_request/0" do
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

    test "queries wikidata sparql api and returns result" do
      assert {:ok, %{body: @sample_response}} = get_ingredients()
    end
  end

  describe "get_ingredients/0 when timeout error occurs" do
    test "returns timeout error on timeout" do
      Tesla.Mock.mock(fn %{method: :get} -> {:error, :timeout} end)

      assert {:error, :wikidata_client_timeout} == get_ingredients()
    end

    test "returns general error when other error occurs" do
      Tesla.Mock.mock(fn %{method: :get} -> {:error, :something_else} end)
      assert {:error, :wikidata_client_error, :something_else} == get_ingredients()
    end
  end
end
