defmodule Dujudu.Schemas.Image do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "images" do
    field :commons_url, :string
    belongs_to :ingredient, Dujudu.Schemas.Ingredient

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:commons_url, :ingredient_id])
    |> validate_required([:commons_url, :ingredient_id])
  end
end
