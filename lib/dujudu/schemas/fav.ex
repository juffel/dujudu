defmodule Dujudu.Schemas.Fav do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "favs" do
    belongs_to :account, Dujudu.Schemas.Account
    belongs_to :ingredient, Dujudu.Schemas.Ingredient

    timestamps()
  end

  @doc false
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:account_id, :ingredient_id])
    |> validate_required([:account_id, :ingredient_id])
  end
end
