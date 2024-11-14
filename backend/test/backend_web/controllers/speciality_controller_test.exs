defmodule BackendWeb.SpecialityControllerTest do
  use BackendWeb.ConnCase

  import Backend.Auth.Guardian

  import Backend.SpecialitiesFixtures

  alias Backend.Specialities.Speciality

  @create_attrs %{
    code: "some code",
    description: "some description",
    title: "some title"
  }
  @update_attrs %{
    code: "some updated code",
    description: "some updated description",
    title: "some updated title"
  }
  @invalid_attrs %{code: nil, description: nil, title: nil}

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
    test "lists all specialities", %{conn: conn} do
      conn = get(conn, ~p"/api/specialities")
      assert json_response(conn, 200)["list"] == []
    end
  end

  describe "create speciality" do
    test "renders speciality when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/specialities", speciality: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, ~p"/api/specialities/#{id}")

      assert %{
               "id" => ^id,
               "code" => "some code",
               "description" => "some description",
               "title" => "some title"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/specialities", speciality: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update speciality" do
    setup [:create_speciality]

    test "renders speciality when data is valid", %{
      conn: conn,
      speciality: %Speciality{id: id} = speciality
    } do
      conn = put(conn, ~p"/api/specialities/#{speciality}", speciality: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/api/specialities/#{id}")

      assert %{
               "id" => ^id,
               "code" => "some updated code",
               "description" => "some updated description",
               "title" => "some updated title"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, speciality: speciality} do
      conn = put(conn, ~p"/api/specialities/#{speciality}", speciality: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete speciality" do
    setup [:create_speciality]

    test "deletes chosen speciality", %{conn: conn, speciality: speciality} do
      conn = delete(conn, ~p"/api/specialities/#{speciality}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/specialities/#{speciality}")
      end
    end
  end

  defp create_speciality(_) do
    speciality = speciality_fixture()
    %{speciality: speciality}
  end
end
