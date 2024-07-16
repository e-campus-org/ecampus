defmodule BackendWeb.AccountJSON do
  alias Backend.Accounts.Account

  @doc """
  Renders a list of accounts.
  """
  def index(%{accounts: accounts}) do
    %{data: for(account <- accounts, do: data(account))}
  end

  @doc """
  Renders a single account.
  """
  def show(%{account: account}) do
    %{data: data(account)}
  end

  defp data(%Account{} = account) do
    %{
      id: account.id,
      email: account.email,
      last_name: account.last_name,
      first_name: account.first_name,
      group_id: account.group_id,
      created_at: account.inserted_at,
      updated_at: account.updated_at
    }
  end

  def token(%{token: token}) do
    %{access_token: token}
  end
end
