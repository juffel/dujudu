defmodule Dujudu.Schemas.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:title, :wikidata_id],
    sortable: [:title]
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ingredients" do
    field :title, :string
    field :unit, Ecto.Enum, values: [:liter, :kilo, :unknown]
    field :wikidata_id, :string

    timestamps()
  end

  @doc false
  def changeset(ingredient, attrs) do
    ingredient
    |> cast(attrs, [:title, :unit, :wikidata_id])
    |> unique_constraint(:wikidata_id)
    |> validate_required([:title, :unit])
  end
end
