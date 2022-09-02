defmodule Dujudu.Schemas.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    compound_fields: [
      title_or_wid: [:title, :wikidata_id],
      instance_of_wid: [:instance_of_wikidata_ids, :subclass_of_wikidata_ids]
    ],
    filterable: [:title_or_wid, :instance_of_wid],
    sortable: [:title],
    default_limit: 48
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  schema "ingredients" do
    field :title, :string
    field :description, :string
    field :wikidata_id, :string

    field :subclass_of_wikidata_ids, {:array, :string}
    field :instance_of_wikidata_ids, {:array, :string}
    field :commons_image_urls, {:array, :string}

    has_many :favs, Dujudu.Schemas.Fav

    timestamps()
  end

  @doc false
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:title, :unit, :wikidata_id])
    |> unique_constraint(:wikidata_id)
    |> validate_required([:title])
  end
end
