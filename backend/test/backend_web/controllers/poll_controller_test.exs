defmodule BackendWeb.PollControllerTest do
  use BackendWeb.ConnCase

  import Backend.PollsFixtures

  alias Backend.Polls.Poll

  @create_attrs %{
    description: "some description",
    title: "some title"
  }
  @update_attrs %{
    description: "some updated description",
    title: "some updated title"
  }
  @invalid_attrs %{description: nil, title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    # test "lists all polls", %{conn: conn} do
    #   conn = get(conn, ~p"/api/polls")
    #   assert json_response(conn, 200)["data"] == []
    # end
  end

  describe "create poll" do
    # test "renders poll when data is valid", %{conn: conn} do
    #   conn = post(conn, ~p"/api/polls", poll: @create_attrs)
    #   assert %{"id" => id} = json_response(conn, 201)["data"]

    #   conn = get(conn, ~p"/api/polls/#{id}")

    #   assert %{
    #            "id" => ^id,
    #            "description" => "some description",
    #            "title" => "some title"
    #          } = json_response(conn, 200)["data"]
    # end

    # test "renders errors when data is invalid", %{conn: conn} do
    #   conn = post(conn, ~p"/api/polls", poll: @invalid_attrs)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "update poll" do
    # setup [:create_poll]

    # test "renders poll when data is valid", %{conn: conn, poll: %Poll{id: id} = poll} do
    #   conn = put(conn, ~p"/api/polls/#{poll}", poll: @update_attrs)
    #   assert %{"id" => ^id} = json_response(conn, 200)["data"]

    #   conn = get(conn, ~p"/api/polls/#{id}")

    #   assert %{
    #            "id" => ^id,
    #            "description" => "some updated description",
    #            "title" => "some updated title"
    #          } = json_response(conn, 200)["data"]
    # end

    # test "renders errors when data is invalid", %{conn: conn, poll: poll} do
    #   conn = put(conn, ~p"/api/polls/#{poll}", poll: @invalid_attrs)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "delete poll" do
    # setup [:create_poll]

    # test "deletes chosen poll", %{conn: conn, poll: poll} do
    #   conn = delete(conn, ~p"/api/polls/#{poll}")
    #   assert response(conn, 204)

    #   assert_error_sent 404, fn ->
    #     get(conn, ~p"/api/polls/#{poll}")
    #   end
    # end
  end

  defp create_poll(_) do
    poll = poll_fixture()
    %{poll: poll}
  end
end
