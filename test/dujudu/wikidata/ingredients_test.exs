defmodule Dujudu.Wikidata.IngredientsTest do
  use DujuduWeb.ConnCase

  import Dujudu.Wikidata.Ingredients, only: [ingredient_data_from_rows: 1]

  @sample_rows File.read!("test/dujudu/wikidata/sample_rows.json")
  @expected_ingredient_data File.read!("test/dujudu/wikidata/expected_data.json")

  describe "ingredient_data_from_rows/1" do
    test "extracts data properly" do
      ingredient_data =
        @sample_rows
        |> Jason.decode!()
        |> ingredient_data_from_rows()

      assert Jason.decode!(@expected_ingredient_data, keys: :atoms) == ingredient_data
    end
  end
end
