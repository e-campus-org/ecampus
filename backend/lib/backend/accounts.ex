defmodule Backend.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Accounts.Account

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts(params \\ %{}),
    do:
      Flop.validate_and_run(Account, params, for: Account)
      |> do_list_accounts()

  defp do_list_accounts(
         {:ok,
          {accounts,
           %{total_pages: pages, total_count: count, flop: %{page: page, page_size: page_size}} =
             _meta}}
       ),
       do: {
         :ok,
         %{
           pagination: %{
             count: count,
             pages: pages,
             page_size: page_size,
             page: page
           },
           list: accounts
         }
       }

  defp do_list_accounts({:error, %{errors: errors}}),
    do: {
      :error,
      %{
        pagination: nil,
        list: nil,
        errors: errors
      }
    }

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Check if default admin exists

  ## Examples

      iex> is_default_admin_exists?()
      true
  """
  def is_default_admin_exists?() do
    query = from(a in Account, where: :admin in a.roles)
    Repo.exists?(query)
  end

  @doc """
  Gets a single account by email.

  ## Examples

      iex> get_by_email('existing_email@example.com')
      %Account{}

      iex> get_by_email('not_existing_email@example.com')
      {:error, :not_found}
  """
  def get_account_by_email(email) do
    case Repo.get_by(Account, email: email) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end
end
