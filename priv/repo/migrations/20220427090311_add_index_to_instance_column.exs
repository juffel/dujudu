defmodule Dujudu.Repo.Migrations.AddIndexToInstanceColumn do
  use Ecto.Migration

  def change do
    create index("ingredients", [:instance_of_wikidata_id])
  end
end
