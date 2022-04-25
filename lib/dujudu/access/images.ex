defmodule Dujudu.Access.Images do
  alias Dujudu.Schemas.{Image, Ingredient}
  alias Dujudu.Wikidata.Images
  alias Dujudu.Repo

  import Ecto.Query, only: [from: 2]
  import Ecto.Query.API, only: [fragment: 1]

  def update_all_images() do
    Ingredient
    |> Repo.all()
    |> Enum.each(fn ingredient ->
      images = Images.fetch_images(ingredient)
      update_ingredient_images(ingredient, images)
    end)
  end

  def update_ingredient_images(%Ingredient{} = ingredient, updated_images) do
    ingredient
    |> Repo.preload(:images)
    |> Ingredient.change_images(updated_images)
    |> Repo.update()
  end

  def sample_image() do
    query = from i in Image, order_by: fragment("RANDOM()"), limit: 1, preload: :ingredient
    Repo.one(query)
  end
end
