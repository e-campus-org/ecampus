defmodule Backend.AccountsTest do
  use Backend.DataCase

  alias Backend.Accounts

  describe "accounts" do
    alias Backend.Accounts.Account

    import Backend.AccountsFixtures

    @invalid_attrs %{email: "invalid email", last_name: nil, first_name: nil}

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      {:ok, %{list: list}} = Accounts.list_accounts()
      assert list == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "default_admin_exists?/0 returns true if default admin exists" do
      account_fixture()
      assert Accounts.default_admin_exists?() == true
    end

    test "default_admin_exists?/0 returns false if default admin  not exists" do
      assert Accounts.default_admin_exists?() == false
    end

    test "get_account_by_email/1 returns the account with given email" do
      account = account_fixture()
      assert Accounts.get_account_by_email(account.email) == {:ok, account}
    end

    test "get_account_by_email/1 returns the error with wrong email" do
      account = account_fixture()
      assert Accounts.get_account_by_email(account.email <> "qwe") == {:error, :not_found}
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()

      update_attrs = %{
        email: "some@updated.email.com",
        last_name: "some updated last_name",
        first_name: "some updated first_name"
      }

      assert {:ok, %Account{} = account} = Accounts.update_account(account, update_attrs)
      assert account.email == "some@updated.email.com"
      assert account.last_name == "some updated last_name"
      assert account.first_name == "some updated first_name"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()

      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end
  end
end
