defmodule Dujudu.Schemas.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dujudu.Schemas.Image

  @derive {
    Flop.Schema,
    filterable: [:title],
    sortable: [:title],
    default_limit: 23
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ingredients" do
    field :title, :string
    field :unit, Ecto.Enum, values: [:liter, :kilo, :unknown]
    field :description, :string
    field :wikidata_id, :string

    has_many :images, Image, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(ingredient, attrs) do
    ingredient
    |> cast(attrs, [:title, :unit, :wikidata_id])
    |> unique_constraint(:wikidata_id)
    |> validate_required([:title])
  end

  @doc """
  Changeset to update images association for an ingredient.
  Ingredient [:images] must be preloaded for this changeset.
  """
  def change_images(%{images: current_images} = ingredient, fetched_images) do
    images = [
      Enum.filter(current_images, fn %{commons_url: url} ->
        Enum.any?(fetched_images, fn %{commons_url: fetched_url} -> url == fetched_url end)
      end),
      Enum.filter(fetched_images, fn %{commons_url: url} ->
        !Enum.any?(current_images, fn %{commons_url: current_url} -> url == current_url end)
      end)
    ] |> List.flatten()

    ingredient
    |> changeset(%{})
    |> put_assoc(:images, images)
  end
end
