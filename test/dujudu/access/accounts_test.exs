defmodule Dujudu.Access.AccountsTest do
  use Dujudu.DataCase, async: true

  import Dujudu.Access.Accounts

  defp insert_account(_) do
    %{account: insert(:account)}
  end

  describe "get/1" do
    setup :insert_account

    test "returns existing account", %{account: %{id: account_id}} do
      account = get(account_id)
      assert account.id == account_id
      refute account.password
    end

    test "returns nil for unknown account id" do
      refute get("00000000-0000-0000-0000-000000000000")
    end
  end

  test "create_account/1" do
    params = %{
      name: "Chang Doe",
      email: "chang@doe.org",
      password: "password123"
    }
    assert {:ok, account} = create_account(params)
    assert account.name == "Chang Doe"
    assert account.email == "chang@doe.org"
    refute account.password

    assert Argon2.check_pass(account, "password123")
  end
end