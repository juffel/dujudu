defmodule Dujudu.Repo.Migrations.CreateFavs do
  use Ecto.Migration

  def change do
    create table(:favs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :account_id, references(:accounts, on_delete: :delete_all, type: :binary_id)
      add :ingredient_id, references(:ingredients, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end

    create index(:favs, [:ingredient_id])
    create index(:favs, [:account_id])
    create unique_index(:favs, [:ingredient_id, :account_id])
  end
end
