defmodule Dujudu.Access.Favs do
  alias Dujudu.Schemas.Fav
  alias Dujudu.Repo

  def get(fav_id) do
    Repo.get(Fav, fav_id)
  end

  def get(account_id, ingredient_id) do
    Repo.get_by(Fav, account_id: account_id, ingredient_id: ingredient_id)
  end

  def create(account_id, ingredient_id) do
    %{account_id: account_id, ingredient_id: ingredient_id}
    |> Fav.create_changeset()
    |> Repo.insert()
  rescue
    _e in Ecto.ConstraintError -> {:error, :duplicate}
  end

  def delete(account_id, ingredient_id) do
    case Repo.get_by(Fav, account_id: account_id, ingredient_id: ingredient_id) do
      nil -> {:error, :not_found}
      fav -> Repo.delete(fav)
    end
  end
end
