defmodule BackendWeb.AccountJSON do
  alias Backend.Accounts.Account

  @doc """
  Renders a list of accounts.
  """
  def index(%{data: {:ok, %{list: list, pagination: pagination}}}) do
    %{list: for(account <- list, do: data(account)), pagination: pagination}
  end

  def index(%{data: {:error, _paylaod}}) do
    %{error: "Wrong params"}
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
      roles: account.roles,
      group_id: account.group_id,
      created_at: account.inserted_at,
      updated_at: account.updated_at
    }
  end
end
