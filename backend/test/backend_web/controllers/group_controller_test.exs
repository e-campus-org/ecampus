defmodule BackendWeb.GroupControllerTest do
  use BackendWeb.ConnCase

  import Backend.Auth.Guardian

  import Backend.GroupsFixtures

  import Backend.SpecialitiesFixtures

  alias Backend.Groups.Group
  alias Backend.Specialities.Speciality

  @create_attrs %{
    description: "some description",
    title: "some title"
  }
  @update_attrs %{
    description: "some updated description",
    title: "some updated title"
  }
  @invalid_attrs %{description: nil, title: nil}

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
    {:ok, _, token} = create_token(@admin_account)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{token}")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all groups", %{conn: conn} do
      conn = get(conn, ~p"/api/groups")
      assert json_response(conn, 200)["list"] == []
    end
  end

  describe "create group" do
    setup [:create_speciality]

    test "renders group when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/groups", group: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, ~p"/api/groups/#{id}")

      expected_description = @create_attrs.description
      expected_title = @create_attrs.title

      assert %{
               "id" => ^id,
               "description" => ^expected_description,
               "title" => ^expected_title
             } = json_response(conn, 200)
    end

    test "renders group when data is valid and speciality id is correct", %{
      conn: conn,
      speciality: %Speciality{id: speciality_id}
    } do
      conn =
        post(conn, ~p"/api/groups", group: Map.put(@create_attrs, :speciality_id, speciality_id))

      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, ~p"/api/groups/#{id}")

      expected_description = @create_attrs.description
      expected_title = @create_attrs.title

      assert %{
               "id" => ^id,
               "description" => ^expected_description,
               "title" => ^expected_title
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/groups", group: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders error where speciality_id is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/groups", group: Map.put(@create_attrs, :speciality_id, 123))
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update group" do
    setup [:create_group, :create_speciality]

    test "renders group when data is valid", %{conn: conn, group: %Group{id: id} = group} do
      conn = put(conn, ~p"/api/groups/#{group}", group: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/api/groups/#{id}")

      expected_description = @update_attrs.description
      expected_title = @update_attrs.title

      assert %{
               "id" => ^id,
               "description" => ^expected_description,
               "title" => ^expected_title
             } = json_response(conn, 200)
    end

    test "renders group when data is valid and speciality id is correct", %{
      conn: conn,
      group: %Group{id: id},
      speciality: %Speciality{id: speciality_id}
    } do
      conn =
        put(conn, ~p"/api/groups/#{id}",
          group: Map.put(@update_attrs, :speciality_id, speciality_id)
        )

      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/api/groups/#{id}")

      expected_description = @update_attrs.description
      expected_title = @update_attrs.title

      assert %{
               "id" => ^id,
               "description" => ^expected_description,
               "title" => ^expected_title,
               "speciality_id" => ^speciality_id
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, group: group} do
      conn = put(conn, ~p"/api/groups/#{group}", group: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders error where speciality_id is invalid", %{conn: conn, group: group} do
      conn =
        put(conn, ~p"/api/groups/#{group}", group: Map.put(@update_attrs, :speciality_id, 123))

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete group" do
    setup [:create_group]

    test "deletes chosen group", %{conn: conn, group: group} do
      conn = delete(conn, ~p"/api/groups/#{group}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/groups/#{group}")
      end
    end
  end

  defp create_group(_) do
    group = group_fixture()
    %{group: group}
  end

  defp create_speciality(_) do
    speciality = speciality_fixture()
    %{speciality: speciality}
  end
end
