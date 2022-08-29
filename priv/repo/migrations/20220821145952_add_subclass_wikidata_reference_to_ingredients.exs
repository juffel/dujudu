defmodule Dujudu.Repo.Migrations.AddSubclassWikidataReferenceToIngredients do
  use Ecto.Migration

  def change do
    alter table(:ingredients) do
      add :subclass_of_wikidata_ids, {:array, :string}
      add :instance_of_wikidata_ids, {:array, :string}

      remove :instance_of_wikidata_id, :string
      remove :unit, :string
    end

    create index("ingredients", [:subclass_of_wikidata_ids])
    create index("ingredients", [:instance_of_wikidata_ids])
  end
end
