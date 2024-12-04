defmodule Backend.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Accounts` context.
  """

  @doc """
  Generate a account.
  """
  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(%{
        first_name: "some first_name",
        last_name: "some last_name",
        email: "some@email.com",
        password: "some password",
        password_confirmation: "some password",
        roles: ["admin"]
      })
      |> Backend.Accounts.create_account()

    account
    |> Map.put(:password, nil)
    |> Map.put(:password_confirmation, nil)
  end
end
