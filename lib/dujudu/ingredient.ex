defmodule Dujudu.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ingredients" do
    field :title, :string
    field :unit, Ecto.Enum, values: [:liter, :kilo]
    field :wikidata_id, :string

    timestamps()
  end

  @doc false
  def changeset(ingredient, attrs) do
    ingredient
    |> cast(attrs, [:title, :unit])
    |> validate_required([:title, :unit])
  end
end
