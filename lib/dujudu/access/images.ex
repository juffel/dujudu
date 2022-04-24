defmodule Dujudu.Access.Images do
  alias Dujudu.Schemas.Ingredient
  alias Dujudu.Wikidata.Images
  alias Dujudu.Repo

  # def update_ingredient_images(ingredients) do
  #   ingredients
  #   |> Enum.each(fn ingredient ->
  #     images = Images.fetch_images(ingredient)
  #     update_images(ingredient, images)
  #   end)
  # end

  def update_ingredient_images(%Ingredient{} = ingredient, updated_images) do

    ingredient
    |> Repo.preload(:images)
    |> Ingredient.change_images(updated_images)
    |> Repo.update()
  end
end
