defmodule Dujudu.Access.ImagesTest do
  use Dujudu.DataCase

  alias Dujudu.Access.Images
  alias Dujudu.Schemas.Image

  describe "update_ingredient_images/2" do
    setup do
      %{
        ingredient:
          insert(:ingredient, images: [
            build(:image, commons_url: "https://foo.bar/outdated"),
            build(:image, commons_url: "https://foo.bar/uptodate")
          ])
      }
    end

    test "keeps included images, adds new ones and deletes unincluded images", %{ingredient: ingredient} do
      fetched_images = [
        build(:image, commons_url: "https://foo.bar/new-wow-yay"),
        build(:image, commons_url: "https://foo.bar/uptodate")
      ]

      Images.update_ingredient_images(ingredient, fetched_images)

      %{images: images} = Repo.preload(ingredient, :images, force: true)

      assert length(images) == 2
      [
        "https://foo.bar/new-wow-yay",
        "https://foo.bar/uptodate"
      ]
      |> Enum.each(fn expected_url ->
        assert Enum.any?(images, fn %{commons_url: found_url} -> found_url == expected_url end)
      end)
    end
  end
end
