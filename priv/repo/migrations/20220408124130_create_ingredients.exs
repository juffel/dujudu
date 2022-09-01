defmodule Dujudu.Repo.Migrations.CreateIngredients do
  use Ecto.Migration

  def change do
    create table(:ingredients, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :unit, :string
      add :wikidata_id, :string
      add :description, :text

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:ingredients, [:wikidata_id])
  end
end
