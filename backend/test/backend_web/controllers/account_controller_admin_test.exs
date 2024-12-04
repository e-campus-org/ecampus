defmodule BackendWeb.AccountControllerAdminTest do
  use BackendWeb.ConnCase

  import Backend.Auth.Guardian

  import Backend.AccountsFixtures

  import Backend.GroupsFixtures

  alias Backend.Accounts.Account

  alias Backend.Groups.Group

  @create_attrs %{
    email: "some@email.com",
    last_name: "some last_name",
    first_name: "some first_name",
    password: "qwerty",
    password_confirmation: "qwerty",
    roles: [:admin]
  }
  @update_attrs %{
    email: "some@updated.email.com",
    last_name: "some updated last_name",
    first_name: "some updated first_name"
  }
  @invalid_attrs %{email: "invalid email", last_name: nil, first_name: nil}

  @admin_account %{
    id: 1,
    first_name: "John",
    last_name: "Doe",
    email: "admin@ecampus.com",
    password: "qwerty",
    password_confirmation: "qwerty",
    roles: [:admin]
  }

  describe "index" do
    setup %{conn: conn} do
      {:ok, _, token} = create_token(@admin_account)

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
    setup [:create_group]

    setup %{conn: conn} do
      {:ok, _, token} = create_token(@admin_account)

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{token}")

      {:ok, conn: conn}
    end

    test "renders account when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/accounts", account: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      expected_email = @create_attrs.email
      expected_first_name = @create_attrs.first_name
      expected_last_name = @create_attrs.last_name

      conn = get(conn, ~p"/api/accounts/#{id}")

      assert %{
               "id" => ^id,
               "email" => ^expected_email,
               "first_name" => ^expected_first_name,
               "last_name" => ^expected_last_name
             } = json_response(conn, 200)
    end

    test "renders account when data is valid and group id is correct", %{
      conn: conn,
      group: %Group{id: group_id}
    } do
      conn =
        post(conn, ~p"/api/accounts", account: Map.put(@create_attrs, :group_id, group_id))

      assert %{"id" => id} = json_response(conn, 201)

      expected_email = @create_attrs.email
      expected_first_name = @create_attrs.first_name
      expected_last_name = @create_attrs.last_name

      conn = get(conn, ~p"/api/accounts/#{id}")

      assert %{
               "id" => ^id,
               "email" => ^expected_email,
               "first_name" => ^expected_first_name,
               "last_name" => ^expected_last_name
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/accounts", account: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders error where group_id is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/accounts", account: Map.put(@create_attrs, :group_id, 0))
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "init" do
    setup %{conn: conn} do
      conn =
        conn
        |> put_req_header("accept", "application/json")

      {:ok, conn: conn}
    end

    test "inti creates initial admin account", %{conn: conn} do
      conn = post(conn, ~p"/api/accounts/init", account: @create_attrs)
      assert conn.status == 201
    end
  end

  describe "update account" do
    setup [:create_account, :create_group]

    setup %{conn: conn} do
      {:ok, _, token} = create_token(@admin_account)

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{token}")

      {:ok, conn: conn}
    end

    test "renders account when data is valid", %{conn: conn, account: %Account{id: id} = account} do
      conn = put(conn, ~p"/api/accounts/#{account}", account: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/api/accounts/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some@updated.email.com",
               "first_name" => "some updated first_name",
               "last_name" => "some updated last_name"
             } = json_response(conn, 200)
    end

    test "renders account when data is valid and group id is correct", %{
      conn: conn,
      account: %Account{id: id},
      group: %Group{id: group_id}
    } do
      conn =
        put(conn, ~p"/api/accounts/#{id}", account: Map.put(@update_attrs, :group_id, group_id))

      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/api/accounts/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some@updated.email.com",
               "first_name" => "some updated first_name",
               "last_name" => "some updated last_name"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, account: account} do
      conn = put(conn, ~p"/api/accounts/#{account}", account: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders error where groupd id is invalid", %{conn: conn, account: account} do
      conn =
        put(conn, ~p"/api/accounts/#{account}", account: Map.put(@update_attrs, :group_id, 0))

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete account" do
    setup [:create_account]

    setup %{conn: conn} do
      {:ok, _, token} = create_token(@admin_account)

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{token}")

      {:ok, conn: conn}
    end

    test "deletes chosen account", %{conn: conn, account: account} do
      conn = delete(conn, ~p"/api/accounts/#{account}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/accounts/#{account}")
      end
    end
  end

  defp create_account(_) do
    account = account_fixture()
    %{account: account}
  end

  defp create_group(_) do
    group = group_fixture()
    %{group: group}
  end
end
