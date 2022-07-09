defmodule Dujudu.Schemas.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :email, :string
    field :name, :string
    field :is_admin, :boolean
    field :password_hash, :string
    field(:password, :string, virtual: true)

    has_many :favs, Dujudu.Schemas.Fav

    timestamps()
  end

  @doc false
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:email, :name, :password])
    |> validate_length(:password, min: 12, max: 128)
    # up-front uniqueness check, there's also a db unique constraint
    |> unsafe_validate_unique(:email, Dujudu.Repo)
    |> put_pass_hash()
    |> validate_required([:email, :password])
    |> delete_change(:password)
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = cs) do
    change(cs, Argon2.add_hash(password))
  end

  defp put_pass_hash(cs), do: cs
end
