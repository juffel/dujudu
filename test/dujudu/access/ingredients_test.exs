defmodule Dujudu.Access.IngredientsTest do
  use DujuduWeb.ConnCase

  alias Dujudu.Schemas.Ingredient
  alias Dujudu.Repo
  alias Dujudu.Wikidata.ClientRequest

  import Dujudu.Access.Ingredients, only: [sample_ingredients: 2, update_ingredients: 0]

  @cache_directory Application.fetch_env!(:dujudu, :wikidata_request_cache_directory)

  setup do
    # remove test artifacts
    on_exit(fn -> File.rm_rf(@cache_directory) end)
  end

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

  describe "update_ingredients/0" do
    @sample_response File.read!("test/dujudu/wikidata/sample_ingredients.json")

    setup do
      Tesla.Mock.mock(fn %{method: :get} ->
        %Tesla.Env{status: 200, body: @sample_response, query: [query: "foo=bar"]}
      end)

      :ok
    end

    test "fills in data from request" do
      assert :ok = update_ingredients()

      ingredients = Repo.all(Ingredient)
      assert %{
        title: "carrot",
        wikidata_id: "Q81",
        commons_image_urls: ["http://commons.wikimedia.org/wiki/Special:FilePath/Another_Carrot_pic.jpg", "http://commons.wikimedia.org/wiki/Special:FilePath/Foo.Bar.02.jpg"],
        description: "rabbits like 'em",
        instance_of_wikidata_ids: ["Q25403900"],
        subclass_of_wikidata_ids: ["Q10675206", "Q2095"],
      } = List.last(ingredients)

      assert [
        %Ingredient{title: "honey"},
        %Ingredient{title: "zucchini"},
        %Ingredient{title: "carrot"}
      ] = ingredients
    end

    test "only updates ingredients with updated values" do
      assert :ok = update_ingredients()

      carrot = Repo.get_by(Ingredient, wikidata_id: "Q81")
      assert %{description: "rabbits like 'em"} = carrot

      # sneakily update cached response
      request = Repo.one(ClientRequest)
      updated_response = String.replace(@sample_response, "rabbits like 'em", "universally delicious root vegetable")
      :ok = File.write(request.file_path, updated_response)

      assert :ok = update_ingredients()

      fresh_carrot = Repo.get_by(Ingredient, wikidata_id: "Q81")
      assert %{description: "universally delicious root vegetable"} = fresh_carrot
      assert fresh_carrot.inserted_at == carrot.inserted_at
      assert fresh_carrot.updated_at != carrot.updated_at
    end
  end
end
