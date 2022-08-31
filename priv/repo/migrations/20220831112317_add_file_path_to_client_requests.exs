defmodule Dujudu.Repo.Migrations.AddFilePathToClientRequests do
  use Ecto.Migration

  def change do
    alter table(:wikidata_client_requests) do
      add :file_path, :string

      remove :response_body, :text
    end
  end
end
