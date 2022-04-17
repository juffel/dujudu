defmodule Dujudu.Repo.Migrations.AddImageUrlToIngredients do
  use Ecto.Migration

  def change do
    alter table(:ingredients) do
      add :description, :string
      add :image_url, :string
    end
  end
end
