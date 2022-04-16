defmodule Dujudu.Wikidata.ClientTest do
  use ExUnit.Case

  @ingredients_query File.read!("lib/dujudu/wikidata/ingredients.sparql")
  @sample_response File.read!("test/dujudu/wikidata/sample_response.json")
  @expected_ingredients [
    %{item: %{type: "uri", value: "http://www.wikidata.org/entity/Q81"}, itemLabel: %{type: "literal", value: "carrot", "xml:lang": "en"}},
    %{item: %{type: "uri", value: "http://www.wikidata.org/entity/Q7533"}, itemLabel: %{type: "literal", value: "zucchini", "xml:lang": "en"}},
    %{item: %{type: "uri", value: "http://www.wikidata.org/entity/Q10987"}, itemLabel: %{type: "literal", value: "honey", "xml:lang": "en"}}
  ]

  describe "get_ingredients/0" do
    import Dujudu.Wikidata.Client, only: [get_ingredients: 0]

    setup do
      Tesla.Mock.mock(fn %{
        method: :get,
        url: "https://query.wikidata.org/sparql",
        headers: [{"accept", "application/sparql-results+json"}],
        query: [query: @ingredients_query]
      } ->
        %Tesla.Env{status: 200, body: @sample_response}
      end)

      :ok
    end

    test "retrieves the current list of ingredients and unpacks response" do
      assert {:ok, @expected_ingredients} == get_ingredients()
    end
  end
end
