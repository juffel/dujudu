defmodule Dujudu.Wikidata.IngredientsTest do
  use ExUnit.Case

  alias Dujudu.Wikidata.Entity

  @sample_response File.read!("test/dujudu/wikidata/sample_ingredients.json")

  setup do
    Tesla.Mock.mock(fn %{method: :get} ->
        %Tesla.Env{status: 200, body: @sample_response}
      end)

      :ok
    end

  describe "fetch_ingredients/0" do
    import Dujudu.Wikidata.Ingredients, only: [fetch_ingredients: 0]

    @expected [
      %Entity{
        title: "honey",
        wikidata_id: "Q10987",
      },
      %Entity{
        title: "zucchini",
        wikidata_id: "Q7533",
      },
      %Entity{
        title: "carrot",
        description: "rabbits like 'em",
        wikidata_id: "Q81",
        instance_of_wikidata_id: "Q12345",
        image_url: "http://commons.wikimedia.org/wiki/Special:FilePath/Foo.Bar.02.jpg",
      },
    ]

    test "calls client and returns a list of maps" do
      assert @expected == sort(fetch_ingredients())
    end

    defp sort(ingredients) do
      Enum.sort_by(ingredients, &(&1.wikidata_id))
    end
  end
end
