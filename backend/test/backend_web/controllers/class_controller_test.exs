defmodule BackendWeb.ClassControllerTest do
  use BackendWeb.ConnCase

  import Backend.ClassesFixtures

  alias Backend.Classes.Class

  @create_attrs %{
    begin_date: ~U[2024-08-11 20:26:00Z],
    classroom: "some classroom"
  }
  @update_attrs %{
    begin_date: ~U[2024-08-12 20:26:00Z],
    classroom: "some updated classroom"
  }
  @invalid_attrs %{begin_date: nil, classroom: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    # test "lists all classes", %{conn: conn} do
    #   conn = get(conn, ~p"/api/classes")
    #   assert json_response(conn, 200)["data"] == []
    # end
  end

  describe "create class" do
    # test "renders class when data is valid", %{conn: conn} do
    #   conn = post(conn, ~p"/api/classes", class: @create_attrs)
    #   assert %{"id" => id} = json_response(conn, 201)["data"]

    #   conn = get(conn, ~p"/api/classes/#{id}")

    #   assert %{
    #            "id" => ^id,
    #            "begin_date" => "2024-08-11T20:26:00Z",
    #            "classroom" => "some classroom"
    #          } = json_response(conn, 200)["data"]
    # end

    # test "renders errors when data is invalid", %{conn: conn} do
    #   conn = post(conn, ~p"/api/classes", class: @invalid_attrs)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "update class" do
    # setup [:create_class]

    # test "renders class when data is valid", %{conn: conn, class: %Class{id: id} = class} do
    #   conn = put(conn, ~p"/api/classes/#{class}", class: @update_attrs)
    #   assert %{"id" => ^id} = json_response(conn, 200)["data"]

    #   conn = get(conn, ~p"/api/classes/#{id}")

    #   assert %{
    #            "id" => ^id,
    #            "begin_date" => "2024-08-12T20:26:00Z",
    #            "classroom" => "some updated classroom"
    #          } = json_response(conn, 200)["data"]
    # end

    # test "renders errors when data is invalid", %{conn: conn, class: class} do
    #   conn = put(conn, ~p"/api/classes/#{class}", class: @invalid_attrs)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "delete class" do
    # setup [:create_class]

    # test "deletes chosen class", %{conn: conn, class: class} do
    #   conn = delete(conn, ~p"/api/classes/#{class}")
    #   assert response(conn, 204)

    #   assert_error_sent 404, fn ->
    #     get(conn, ~p"/api/classes/#{class}")
    #   end
    # end
  end

  defp create_class(_) do
    class = class_fixture()
    %{class: class}
  end
end
