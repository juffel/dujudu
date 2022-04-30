defmodule Dujudu.Wikidata.ClientRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wikidata_client_requests" do
    field :query, :string
    field :response_body, :string

    timestamps()
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:query, :response_body])
  end
end
