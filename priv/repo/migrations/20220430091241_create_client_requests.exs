defmodule Dujudu.Repo.Migrations.CreateClientRequests do
  use Ecto.Migration

  def change do
    create table(:wikidata_client_requests) do
      add :query, :text
      add :response_body, :text

      timestamps(type: :utc_datetime_usec)
    end
  end
end
