defmodule Dujudu.Access.Accounts do
  alias Dujudu.Repo
  alias Dujudu.Schemas.Account

  def get(id) do
    Repo.get(Account, id)
  end

  def create_account(params) do
    params
    |> Account.create_changeset()
    |> Repo.insert()
  end
end