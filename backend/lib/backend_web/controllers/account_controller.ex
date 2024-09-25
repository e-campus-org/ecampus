defmodule BackendWeb.AccountController do
  use BackendWeb, :controller

  alias Backend.Accounts
  alias Backend.Accounts.Account

  import Backend.Auth.Plugs

  action_fallback(BackendWeb.FallbackController)

  plug(:is_admin when action in [:create, :delete])

  def index(conn, %{"page" => _page, "page_size" => _page_size} = params) do
    data = Accounts.list_accounts(params)
    render(conn, :index, data: data)
  end

  def index(conn, _params) do
    data = Accounts.list_accounts(%{"page" => 1, "page_size" => 10})
    render(conn, :index, data: data)
  end

  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/accounts/#{account}")
      |> render(:show, account: account)
    end
  end

  def init(conn, %{"account" => account_params}) do
    Accounts.is_default_admin_exists?()
    |> do_init(conn, account_params)
  end

  defp do_init(true, conn, _params), do: conn |> send_resp(:conflict, "")

  defp do_init(false, conn, params) do
    account_params =
      params
      |> Map.put("roles", ["admin"])
      |> Map.put("group_id", nil)

    with {:ok, _} <- Accounts.create_account(account_params) do
      conn |> send_resp(:created, "")
    end
  end

  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    render(conn, :show, account: account)
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{} = account} <- Accounts.update_account(account, account_params) do
      render(conn, :show, account: account)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
