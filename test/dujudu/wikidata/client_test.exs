defmodule Dujudu.Wikidata.ClientTest do
  use ExUnit.Case

  @ingredients_query File.read!("lib/dujudu/wikidata/queries/ingredients.sparql")
  @sample_response File.read!("test/dujudu/wikidata/sample_ingredients.json")

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

  @ingredient_id "Q1548030"
  @ingredient_images_query File.read!("test/dujudu/wikidata/sample_ingredient_images.sparql")
  @ingredient_images_response File.read!("test/dujudu/wikidata/sample_ingredient_images.json")
  @expected_images [
    %{image: %{type: "uri", value: "http://commons.wikimedia.org/wiki/Special:FilePath/Red%20capsicum%20and%20cross%20section.jpg"}},
    %{image: %{type: "uri", value: "http://commons.wikimedia.org/wiki/Special:FilePath/RedBellPepper.jpg"}}
  ]

  describe "get_ingredient_images/1" do
    import Dujudu.Wikidata.Client, only: [get_ingredient_images: 1]

    setup do
      Tesla.Mock.mock(fn %{
        method: :get,
        url: "https://query.wikidata.org/sparql",
        headers: [{"accept", "application/sparql-results+json"}],
        query: [query: @ingredient_images_query]
      } ->
        %Tesla.Env{status: 200, body: @ingredient_images_response}
      end)

      :ok
    end

    test "retrieves images for the given ingredient and unpacks response" do
      assert {:ok, @expected_images} == get_ingredient_images(@ingredient_id)
    end
  end
end
