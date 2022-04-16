defmodule Dujudu.Wikidata.IngredientsTest do
  use ExUnit.Case

  @sample_response File.read!("test/dujudu/wikidata/sample_response.json")

  setup do
    Tesla.Mock.mock(fn %{method: :get} ->
        %Tesla.Env{status: 200, body: @sample_response}
      end)

      :ok
    end

  describe "fetch_ingredients/0" do
    import Dujudu.Wikidata.Ingredients, only: [fetch_ingredients: 0]

    alias Dujudu.Schemas.Ingredient

    @expected_ingredients [
      %Ingredient{
        title: "carrot", wikidata_id: "http://www.wikidata.org/entity/Q81",
      },
      %Ingredient{
        title: "honey", wikidata_id: "http://www.wikidata.org/entity/Q10987",
      },
      %Ingredient{
        title: "zucchini", wikidata_id: "http://www.wikidata.org/entity/Q7533",
      }
    ]

    test "calls client and returns a list of ingredients" do
      assert sort(@expected_ingredients) == sort(fetch_ingredients())
    end

    defp sort(ingredients) do
      Enum.sort_by(ingredients, &(&1.wikidata_id))
    end
  end
end
