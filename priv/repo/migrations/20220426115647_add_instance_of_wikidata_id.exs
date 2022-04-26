defmodule Dujudu.Repo.Migrations.AddInstanceOfWikidataId do
  use Ecto.Migration

  def change do
    alter table(:ingredients) do
      add :instance_of_wikidata_id, :string
    end
  end
end
