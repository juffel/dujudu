defmodule Dujudu.Wikidata.EntityDataClientTest do
  use DujuduWeb.ConnCase

  import Dujudu.Wikidata.EntityDataClient

  alias Dujudu.Repo

  describe "get_data/1" do
    setup do
      # Tesla.Mock.mock(fn %{
      #                      method: :get,
      #                      url: "https://query.wikidata.org/sparql",
      #                      headers: [{"accept", "application/sparql-results+json"}],
      #                      query: [query: @ingredients_query]
      #                    } ->
      #   %Tesla.Env{
      #     status: 200,
      #     query: [query: @ingredients_query],
      #     body: @sample_response
      #   }
      # end)

      :ok
    end

    test "retrieves the current list of ingredients" do
      {:ok, response} = get_data("Q42")
      File.write("test/dujudu/wikidata/sample_entity_data.json", response) |> IO.inspect()
    end
  end
end
