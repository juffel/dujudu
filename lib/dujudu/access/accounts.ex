defmodule Dujudu.Access.Accounts do
  alias Dujudu.Repo
  alias Dujudu.Schemas.Account

  def get(id) do
    Repo.get(Account, id)
  end

  def get_by_email(email) do
    Repo.get_by(Account, email: email)
  end

  def create(params) do
    params
    |> Account.create_changeset()
    |> Repo.insert()
  end
end
