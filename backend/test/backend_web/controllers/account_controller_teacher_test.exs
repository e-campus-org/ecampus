defmodule BackendWeb.AccountControllerTeacherTest do
  use BackendWeb.ConnCase

  import Backend.Auth.Guardian

  import Backend.AccountsFixtures

  alias Backend.Accounts.Account

  @create_attrs %{
    email: "some@email.com",
    last_name: "some last_name",
    first_name: "some first_name",
    password: "qwerty",
    password_confirmation: "qwerty",
    roles: ["admin"]
  }
  @update_attrs %{
    email: "some@updated.email.com",
    last_name: "some updated last_name",
    first_name: "some updated first_name"
  }

  @account %{
    id: 1,
    first_name: "John",
    last_name: "Doe",
    email: "admin@ecampus.com",
    password: "qwerty",
    password_confirmation: "qwerty",
    roles: [:teacher]
  }

  setup %{conn: conn} do
    conn = conn |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  describe "index" do
    setup %{conn: conn} do
      {:ok, _, token} = create_token(@account)

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{token}")

      {:ok, conn: conn}
    end

    test "lists all accounts", %{conn: conn} do
      conn = get(conn, ~p"/api/accounts")
      assert json_response(conn, 200)["list"] == []
    end
  end

  describe "create account" do
    setup %{conn: conn} do
      {:ok, _, token} = create_token(@account)

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{token}")

      {:ok, conn: conn}
    end

    test "renders errors when trying to create an account", %{conn: conn} do
      conn = post(conn, ~p"/api/accounts", account: @create_attrs)
      assert json_response(conn, 403)["error"] != ""
    end
  end

  describe "update other account" do
    setup [:create_account]

    setup %{conn: conn} do
      {:ok, _, token} = create_token(%{@account | id: 222})

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{token}")

      {:ok, conn: conn}
    end

    test "renders errors trying to update other account", %{conn: conn, account: account} do
      conn = put(conn, ~p"/api/accounts/#{account}", account: @update_attrs)
      assert json_response(conn, 403)["error"] != ""
    end
  end

  describe "update your account" do
    setup [:create_account]

    setup %{conn: conn, account: %Account{id: id} = account} do
      conn =
        conn
        |> put_req_header("accept", "application/json")

      {:ok, conn: conn}
    end

    test "renders account when data is valid", %{conn: conn, account: %Account{id: id} = account} do
      {:ok, _, token} = create_token(account)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> put(~p"/api/accounts/#{id}", account: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/api/accounts/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some@updated.email.com",
               "first_name" => "some updated first_name",
               "last_name" => "some updated last_name"
             } = json_response(conn, 200)
    end
  end

  defp create_account(_) do
    account = account_fixture(%{roles: [:teacher]})
    %{account: account}
  end
end
