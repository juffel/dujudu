defmodule Dujudu.Repo.Migrations.AddImagesUrlsColumnToIngredients do
  use Ecto.Migration

  def change do
    alter table(:ingredients) do
      add :commons_image_urls, {:array, :text}, default: []
    end
  end
end
