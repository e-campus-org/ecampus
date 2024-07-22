defmodule Backend.AccountsTest do
  use Backend.DataCase

  alias Backend.Accounts

  describe "accounts" do
    alias Backend.Accounts.Account

    import Backend.AccountsFixtures

    @invalid_attrs %{email: nil, last_name: nil, first_name: nil, email: nil}

    # test "list_accounts/0 returns all accounts" do
    #   account = account_fixture()
    #   assert Accounts.list_accounts() == [account]
    # end

    # test "get_account!/1 returns the account with given id" do
    #   account = account_fixture()
    #   assert Accounts.get_account!(account.id) == account
    # end

    # test "create_account/1 with valid data creates a account" do
    #   valid_attrs = %{email: "some email", last_name: "some last_name", first_name: "some first_name"}

    #   assert {:ok, %Account{} = account} = Accounts.create_account(valid_attrs)
    #   assert account.email == "some email"
    #   assert account.last_name == "some last_name"
    #   assert account.first_name == "some first_name"
    # end

    # test "create_account/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    # end

    # test "update_account/2 with valid data updates the account" do
    #   account = account_fixture()
    #   update_attrs = %{email: "some updated email", last_name: "some updated last_name", first_name: "some updated first_name"}

    #   assert {:ok, %Account{} = account} = Accounts.update_account(account, update_attrs)
    #   assert account.email == "some updated email"
    #   assert account.last_name == "some updated last_name"
    #   assert account.first_name == "some updated first_name"
    # end

    # test "update_account/2 with invalid data returns error changeset" do
    #   account = account_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
    #   assert account == Accounts.get_account!(account.id)
    # end

    # test "delete_account/1 deletes the account" do
    #   account = account_fixture()
    #   assert {:ok, %Account{}} = Accounts.delete_account(account)
    #   assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    # end

    # test "change_account/1 returns a account changeset" do
    #   account = account_fixture()
    #   assert %Ecto.Changeset{} = Accounts.change_account(account)
    # end
  end
end
