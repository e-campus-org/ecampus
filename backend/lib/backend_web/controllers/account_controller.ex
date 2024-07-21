defmodule BackendWeb.AccountController do
  use BackendWeb, :controller

  use PhoenixSwagger

  alias Backend.Accounts
  alias Backend.Accounts.Account

  import Backend.Auth.Plugs

  action_fallback(BackendWeb.FallbackController)

  plug(:is_admin when action in [:create, :delete])

  def swagger_definitions do
    %{
      Account:
        swagger_schema do
          title("Account")
          description("An user account of the application")

          properties do
            id(:number, "Unique identifier")
            email(:string, "User email")
            first_name(:string, "User first name")
            last_name(:string, "User last name")

            roles(:array, "User roles",
              enum: [:admin, :teacher, :student],
              default: [:student]
            )

            group_id(:number, "Id od the user group, if exists")
            inserted_at(:datetime, "Date and time of account creation")
            updated_at(:datetime, "Date and time of account last update")
          end

          example(%{
            id: 1,
            email: "test@example.com",
            first_name: "John",
            last_name: "Doe",
            roles: ["student"],
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
            group_id(:number, "Id of the user group, if exists")
            password(:string, "User password", required: true)
            password_confirmation(:string, "User password confirmation", required: true)

            roles(:array, "User roles",
              enum: [:admin, :teacher, :student],
              default: [:student],
              required: true
            )
          end

          example(%{
            email: "test@example.com",
            first_name: "John",
            last_name: "Doe",
            group_id: 1,
            roles: ["student"],
            password: "Qwerty123!",
            password_confirmation: "Qwerty123!"
          })
        end,
      NewDefaultAccount:
        swagger_schema do
          title("New default admin account")
          description("Data object to create new default admin account")

          properties do
            email(:string, "Admin email", required: true)
            first_name(:string, "Admin first name")
            last_name(:string, "Admin last name")
            password(:string, "Admin password", required: true)
            password_confirmation(:string, "Admin password confirmation", required: true)
          end

          example(%{
            email: "test@example.com",
            first_name: "John",
            last_name: "Doe",
            password: "Qwerty123!",
            password_confirmation: "Qwerty123!"
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

            roles(:array, "User roles",
              enum: [:admin, :teacher, :student],
              default: [:student]
            )
          end

          example(%{
            first_name: "John",
            last_name: "Doe",
            group_id: 1,
            roles: ["student"]
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

    security([%{bearer: []}])

    response(200, "Success", Schema.ref(:Accounts))
  end

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :index, accounts: accounts)
  end

  swagger_path :create do
    post("/accounts")
    summary("Create new account")
    description("Create new account.")
    produces("application/json")
    tag("Accounts")

    security([%{bearer: []}])

    parameters do
      account(:body, Schema.ref(:NewAccount), "Data to create account", required: true)
    end

    response(201, "Success", Schema.ref(:Accounts))
    response(422, "Unprocessable entity (something wrong with body)")
    response(400, "Bad request (Unknown error)")
  end

  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/accounts/#{account}")
      |> render(:show, account: account)
    end
  end

  swagger_path :init do
    post("/accounts/init")
    summary("Create new default admin account")

    description(
      "Create new default admin account. Allowed only when no accounts presents in the database on application first startup"
    )

    produces("application/json")
    tag("Accounts")

    parameters do
      account(:body, Schema.ref(:NewDefaultAccount), "Data to create new default admin account",
        required: true
      )
    end

    response(201, "Success")
    response(422, "Unprocessable entity (something wrong with body)")
    response(400, "Bad request (Unknown error)")
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

  swagger_path :show do
    get("/accounts/{id}")
    summary("Query single account by id")
    description("Query single account by id.")
    produces("application/json")
    tag("Accounts")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Account id", required: true)
    end

    response(200, "Success", Schema.ref(:Account))
    response(404, "Not found (account doesn't exists)")
    response(400, "Bad request (Unknown error)")
  end

  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    render(conn, :show, account: account)
  end

  swagger_path :update do
    put("/accounts/{id}")
    summary("Update existing account")
    description("Update existing account.")
    produces("application/json")
    tag("Accounts")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Account id", required: true)
      account(:body, Schema.ref(:NewAccount), "Data to create account", required: true)
    end

    response(200, "Success", Schema.ref(:Accounts))
    response(404, "Not found (account doesn't exists)")
    response(422, "Unprocessable entity (something wrong with body)")
    response(400, "Bad request (Unknown error)")
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{} = account} <- Accounts.update_account(account, account_params) do
      render(conn, :show, account: account)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/accounts/{id}")
    summary("Delete account by id")
    description("Delete account by id.")
    tag("Accounts")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Account id", required: true)
    end

    response(204, "No content (account deleted)")
    response(404, "Not found (account doesn't exists)")
    response(400, "Bad request (Unknown error)")
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
