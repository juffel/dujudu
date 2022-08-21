defmodule Dujudu.Repo.Migrations.AddSubclassWikidataReferenceToIngredients do
  use Ecto.Migration

  def change do
    alter table(:ingredients) do
      add :subclass_of_wikidata_id, :string
    end

    create index("ingredients", [:subclass_of_wikidata_id])
  end
end
