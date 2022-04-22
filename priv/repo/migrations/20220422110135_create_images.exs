defmodule Dujudu.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:ingredient_images, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :commons_url, :string
      add :ingredient_id, references(:ingredients, type: :binary_id)

      timestamps()
    end
  end
end