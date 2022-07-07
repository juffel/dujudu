defmodule Dujudu.Access.AccountsTest do
  use Dujudu.DataCase, async: true

  alias Dujudu.Access.Accounts

  defp insert_account(_) do
    %{account: insert(:account)}
  end

  describe "get/1" do
    setup :insert_account

    test "returns existing account", %{account: %{id: account_id}} do
      account = Accounts.get(account_id)
      assert account.id == account_id
      refute account.password
    end

    test "returns nil for unknown account id" do
      refute Accounts.get("00000000-0000-0000-0000-000000000000")
    end
  end

  describe "get_by_email/1" do
    setup :insert_account

    test "returns existing account", %{account: %{id: account_id, email: account_email}} do
      account = Accounts.get_by_email(account_email)
      assert account.id == account_id
      refute account.password
    end

    test "returns nil for unknown account id" do
      refute Accounts.get_by_email("nopedy@nope.nope")
      refute Accounts.get_by_email("")
    end
  end

  describe "create/1" do
    test "creates account" do
      params = %{
        name: "Chang Doe",
        email: "chang@doe.org",
        password: "passwordpassword123"
      }
      assert {:ok, account} = Accounts.create(params)
      assert account.name == "Chang Doe"
      assert account.email == "chang@doe.org"
      refute account.password

      assert Argon2.check_pass(account, "passwordpassword123")
    end

    test "does not create account when password is too short" do
      params = %{
        name: "Chang Doe",
        email: "chang@doe.org",
        password: "password123"
      }

      assert {:error, cs} = Accounts.create(params)
      assert cs.errors == [
        password: {"should be at least %{count} character(s)",
        [count: 12, validation: :length, kind: :min, type: :string]}
      ]
    end
  end
end