defmodule BackendWeb.AccountControllerTest do
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
  @invalid_attrs %{email: "invalid email", last_name: nil, first_name: nil}

  @admin_account %{
    id: 1,
    first_name: "John",
    last_name: "Doe",
    email: "admin@ecampus.com",
    password: "qwerty",
    password_confirmation: "qwerty",
    roles: ["admin"]
  }

  setup %{conn: conn} do
    user_claims = %{
      "id" => @admin_account.id,
      "email" => @admin_account.email,
      "roles" => @admin_account.roles
    }

    {:ok, _, token} = create_token(@admin_account)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{token}")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all accounts", %{conn: conn} do
      conn = get(conn, ~p"/api/accounts")
      assert json_response(conn, 200)["list"] == []
    end
  end

  describe "create account" do
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

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/accounts", account: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  # describe "update account" do
  #   setup [:create_account]

  #   test "renders account when data is valid", %{conn: conn, account: %Account{id: id} = account} do
  #     conn = put(conn, ~p"/api/accounts/#{account}", account: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get(conn, ~p"/api/accounts/#{id}")

  #     assert %{
  #              "id" => ^id,
  #              "email" => "some updated email",
  #              "first_name" => "some updated first_name",
  #              "last_name" => "some updated last_name"
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, account: account} do
  #     conn = put(conn, ~p"/api/accounts/#{account}", account: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete account" do
  #   setup [:create_account]

  #   test "deletes chosen account", %{conn: conn, account: account} do
  #     conn = delete(conn, ~p"/api/accounts/#{account}")
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, ~p"/api/accounts/#{account}")
  #     end
  #   end
  # end

  defp create_account(_) do
    account = account_fixture()
    %{account: account}
  end
end
