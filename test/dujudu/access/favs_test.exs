defmodule Dujudu.Access.FavsTest do
  use Dujudu.DataCase, async: true

  alias Dujudu.Access.Favs
  alias Dujudu.Schemas.Fav

  defp insert_fav(_) do
    account = insert(:account)
    ingredient = insert(:ingredient)
    %{
      account: account,
      fav: insert(:fav, account: account, ingredient: ingredient)
    }
  end

  describe "get/1" do
    setup :insert_fav

    test "returns existing fav", %{fav: %{id: fav_id}} do
      fav = Favs.get(fav_id)
      assert fav.id == fav_id
    end

    test "returns nil for unknown fav id" do
      refute Favs.get("00000000-0000-0000-0000-000000000000")
    end
  end

  describe "create/2" do
    test "inserts new fav" do
      account = insert(:account)
      ingredient = insert(:ingredient)

      {:ok, fav} = Favs.create(account.id, ingredient.id)
      assert fav.account_id == account.id
      assert fav.ingredient_id == ingredient.id
    end

    test "returns error when trying to create duplicates" do
      account = insert(:account)
      ingredient = insert(:ingredient)

      assert {:ok, _fav} = Favs.create(account.id, ingredient.id)
      assert {:error, :duplicate} = Favs.create(account.id, ingredient.id)
    end
  end

  describe "delete/2" do
    setup :insert_fav

    test "deletes fav of the given account", %{fav: fav} do
      assert {:ok, _fav} = Favs.delete(fav.account_id, fav.ingredient_id)
      refute Repo.get(Fav, fav.id)
    end

    test "errors when providing a different account", %{fav: fav} do
      other_account = insert(:account)
      assert {:error, _fav} = Favs.delete(other_account.id, fav.ingredient_id)
    end
  end
end
