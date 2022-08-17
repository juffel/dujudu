defmodule Dujudu.Schemas.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dujudu.Schemas.Image

  @derive {
    Flop.Schema,
    compound_fields: [title_or_wid: [:title, :wikidata_id]],
    filterable: [:title_or_wid], sortable: [:title], default_limit: 50
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ingredients" do
    field :title, :string
    field :unit, Ecto.Enum, values: [:liter, :kilo, :unknown]
    field :description, :string
    field :wikidata_id, :string

    has_many :images, Image, on_replace: :delete

    belongs_to :instance_of, __MODULE__,
      foreign_key: :instance_of_wikidata_id,
      references: :wikidata_id,
      type: :binary,
      primary_key: false

    has_many :instances, __MODULE__,
      foreign_key: :instance_of_wikidata_id,
      references: :wikidata_id

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
