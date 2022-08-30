defmodule Dujudu.Access.IngredientsTest do
  use DujuduWeb.ConnCase

  import Dujudu.Access.Ingredients, only: [sample_ingredients: 2]

  describe "sample_ingredients/2" do
    setup do
      # set explicit :wikidata_id to ensure deterministic sort order
      %{
        ingredients: %{
          with_image: insert(:ingredient, commons_image_urls: ["fooooourl"], wikidata_id: "Q123"),
          with_images:
            insert(:ingredient, commons_image_urls: ["booourl", "schnourl"], wikidata_id: "Q124"),
          without_image: insert(:ingredient, commons_image_urls: [], wikidata_id: "Q125")
        }
      }
    end

    test "returns ingredients with image" do
      result = sample_ingredients(2, "seed")
      assert [["fooooourl"], ["booourl", "schnourl"]] == Enum.map(result, & &1.commons_image_urls)
    end

    test "limits result by parameter" do
      _extra_ingredient =
        insert(:ingredient, commons_image_urls: ["blargel"], wikidata_id: "Q126")

      result = sample_ingredients(2, "seed")
      assert length(result) == 2
    end

    test "provides deterministic random order based on seed" do
      result1 = sample_ingredients(2, "seed")
      result2 = sample_ingredients(2, "SEED")

      assert [["fooooourl"], ["booourl", "schnourl"]] ==
               result1 |> Enum.map(& &1.commons_image_urls)

      assert [["booourl", "schnourl"], ["fooooourl"]] ==
               result2 |> Enum.map(& &1.commons_image_urls)
    end
  end
end
