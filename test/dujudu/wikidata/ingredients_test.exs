defmodule Dujudu.Wikidata.IngredientsTest do
  use DujuduWeb.ConnCase

  alias Dujudu.Wikidata.Entity

  @sample_response File.read!("test/dujudu/wikidata/sample_ingredients.json")

  setup do
    Tesla.Mock.mock(fn %{method: :get} ->
      %Tesla.Env{status: 200, body: @sample_response}
    end)

    :ok
  end

  describe "fetch_cached_ingredients/0" do
    import Dujudu.Wikidata.Ingredients, only: [fetch_cached_ingredients: 0]

    @expected [
      %Entity{
        title: "honey",
        wikidata_id: "Q10987"
      },
      %Entity{
        title: "zucchini",
        wikidata_id: "Q7533"
      },
      %Entity{
        title: "carrot",
        description: "rabbits like 'em",
        wikidata_id: "Q81",
        instance_of_wikidata_id: "Q12345",
        commons_image_url: "http://commons.wikimedia.org/wiki/Special:FilePath/Foo.Bar.02.jpg"
      },
      %Dujudu.Wikidata.Entity{
        title: "carrot",
        description: "rabbits like 'em",
        wikidata_id: "Q81",
        instance_of_wikidata_id: "Q654321",
        commons_image_url:
          "http://commons.wikimedia.org/wiki/Special:FilePath/Another_Carrot_pic.jpg"
      }
    ]

    test "calls client and returns a list of maps" do
      assert @expected == sort(fetch_cached_ingredients())
    end

    defp sort(ingredients) do
      Enum.sort_by(ingredients, & &1.wikidata_id)
    end
  end
end
