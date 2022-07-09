defmodule DujuduWeb.IngredientViewTest do
  use DujuduWeb.ConnCase, async: true

  describe "resize_wikidata_image/2" do
    import Dujudu.Wikidata.ImageUrls, only: [resize_wikidata_image: 2]

    test "returns proper url" do
      image_url = "http://commons.wikimedia.org/wiki/Special:FilePath/AllspiceSeeds.jpg"

      expected_url =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/AllspiceSeeds.jpg/320px-AllspiceSeeds.jpg"

      assert expected_url == resize_wikidata_image(image_url, 320)
    end

    test "returns proper url for url with spaces" do
      image_url =
        "http://commons.wikimedia.org/wiki/Special:FilePath/990515%20%2815%29%20-%20Green%20Slim%20Peppers.jpg"

      expected_url =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/990515_(15)_-_Green_Slim_Peppers.jpg/320px-990515_(15)_-_Green_Slim_Peppers.jpg"

      assert expected_url == resize_wikidata_image(image_url, 320)
    end

    test "returns nil when passed nil url" do
      refute resize_wikidata_image(nil, 123)
    end
  end
end
