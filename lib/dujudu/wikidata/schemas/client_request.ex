defmodule Dujudu.Wikidata.ClientRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wikidata_client_requests" do
    field :query, :string
    field :file_path, :string

    timestamps()
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:query, :file_path])
    |> validate_required([:query, :file_path])
  end
end
