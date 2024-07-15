defmodule BackendWeb.AccountController do
  use BackendWeb, :controller

  use PhoenixSwagger

  alias Backend.Accounts
  alias Backend.Accounts.Account

  action_fallback(BackendWeb.FallbackController)

  def swagger_definitions do
    %{
      Account:
        swagger_schema do
          title("Account")
          description("An user account of the application")

          properties do
            id(:number, "Unique identifier", required: true)
            email(:string, "User email", required: true)
            first_name(:string, "User first name")
            last_name(:string, "User last name")
            group_id(:number, "Id od the user group, if exists")
            inserted_at(:datetime, "Date and time of account creation")
            updated_at(:datetime, "Date and time of account last update")
          end

          example(%{
            id: 1,
            email: "test@example.com",
            first_name: "John",
            last_name: "Doe",
            group_id: 1,
            inserted_at: "2024-07-11T05:47:50Z",
            updated_at: "2024-07-11T05:47:50Z"
          })
        end,
      Accounts:
        swagger_schema do
          title("List of accounts")
          description("A collection of Account")
          type(:array)
          items(Schema.ref(:Account))
        end,
      NewAccount:
        swagger_schema do
          title("New account")
          description("Data object to create new account")

          properties do
            email(:string, "User email", required: true)
            first_name(:string, "User first name")
            last_name(:string, "User last name")
            group_id(:number, "Id od the user group, if exists")
          end

          example(%{
            email: "test@example.com",
            first_name: "John",
            last_name: "Doe",
            group_id: 1
          })
        end,
      UpdateAccount:
        swagger_schema do
          title("Update existing account")
          description("Data object to update new account")

          properties do
            first_name(:string, "User first name")
            last_name(:string, "User last name")
            group_id(:number, "Id od the user group, if exists")
          end

          example(%{
            first_name: "John",
            last_name: "Doe",
            group_id: 1
          })
        end
    }
  end

  swagger_path :index do
    get("/accounts")
    summary("Query for accounts")
    description("Query for all accounts. This operation doesn't support pagination yet.")
    produces("application/json")
    tag("Accounts")
    response(200, "Success", Schema.ref(:Accounts))
  end

  swagger_path :show do
    get("/accounts/{id}")
    summary("Query single account by id")
    description("Query single account by id.")
    produces("application/json")
    tag("Accounts")

    parameters do
      id(:path, :number, "Account id", required: true)
    end

    response(200, "Success", Schema.ref(:Account))
    response(404, "Not found (account doesn't exists)")
    response(400, "Bad request (Unknown error)")
  end

  swagger_path :create do
    post("/accounts")
    summary("Create new account")
    description("Create new account.")
    produces("application/json")
    tag("Accounts")

    parameters do
      account(:body, Schema.ref(:NewAccount), "Data to create account", required: true)
    end

    response(200, "Success", Schema.ref(:Accounts))
  end

  swagger_path :update do
    put("/accounts/{id}")
    summary("Update existing account")
    description("Update existing account.")
    produces("application/json")
    tag("Accounts")

    parameters do
      id(:path, :number, "Account id", required: true)
      account(:body, Schema.ref(:NewAccount), "Data to create account", required: true)
    end

    response(200, "Success", Schema.ref(:Accounts))
    response(404, "Not found (account doesn't exists)")
    response(422, "Unprocessable entity (something wrong with body)")
    response(400, "Bad request (Unknown error)")
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/accounts/{id}")
    summary("Delete account by id")
    description("Delete account by id.")
    tag("Accounts")

    parameters do
      id(:path, :number, "Account id", required: true)
    end

    response(204, "No content (account deleted)")
    response(404, "Not found (account doesn't exists)")
    response(400, "Bad request (Unknown error)")
  end

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :index, accounts: accounts)
  end

  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/accounts/#{account}")
      |> render(:show, account: account)
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
