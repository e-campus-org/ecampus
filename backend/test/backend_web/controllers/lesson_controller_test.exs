defmodule BackendWeb.LessonControllerTest do
  use BackendWeb.ConnCase

  import Backend.LessonsFixtures

  alias Backend.Lessons.Lesson

  @create_attrs %{
    description: "some description",
    title: "some title",
    topic: "some topic",
    is_draft: true
  }
  @update_attrs %{
    description: "some updated description",
    title: "some updated title",
    topic: "some updated topic",
    is_draft: false
  }
  @invalid_attrs %{description: nil, title: nil, topic: nil, is_draft: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    # test "lists all lessons", %{conn: conn} do
    #   conn = get(conn, ~p"/api/lessons")
    #   assert json_response(conn, 200)["data"] == []
    # end
  end

  describe "create lesson" do
    # test "renders lesson when data is valid", %{conn: conn} do
    #   conn = post(conn, ~p"/api/lessons", lesson: @create_attrs)
    #   assert %{"id" => id} = json_response(conn, 201)["data"]

    #   conn = get(conn, ~p"/api/lessons/#{id}")

    #   assert %{
    #            "id" => ^id,
    #            "description" => "some description",
    #            "is_draft" => true,
    #            "title" => "some title",
    #            "topic" => "some topic"
    #          } = json_response(conn, 200)["data"]
    # end

    # test "renders errors when data is invalid", %{conn: conn} do
    #   conn = post(conn, ~p"/api/lessons", lesson: @invalid_attrs)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "update lesson" do
    # setup [:create_lesson]

    # test "renders lesson when data is valid", %{conn: conn, lesson: %Lesson{id: id} = lesson} do
    #   conn = put(conn, ~p"/api/lessons/#{lesson}", lesson: @update_attrs)
    #   assert %{"id" => ^id} = json_response(conn, 200)["data"]

    #   conn = get(conn, ~p"/api/lessons/#{id}")

    #   assert %{
    #            "id" => ^id,
    #            "description" => "some updated description",
    #            "is_draft" => false,
    #            "title" => "some updated title",
    #            "topic" => "some updated topic"
    #          } = json_response(conn, 200)["data"]
    # end

    # test "renders errors when data is invalid", %{conn: conn, lesson: lesson} do
    #   conn = put(conn, ~p"/api/lessons/#{lesson}", lesson: @invalid_attrs)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "delete lesson" do
    # setup [:create_lesson]

    # test "deletes chosen lesson", %{conn: conn, lesson: lesson} do
    #   conn = delete(conn, ~p"/api/lessons/#{lesson}")
    #   assert response(conn, 204)

    #   assert_error_sent 404, fn ->
    #     get(conn, ~p"/api/lessons/#{lesson}")
    #   end
    # end
  end

  defp create_lesson(_) do
    lesson = lesson_fixture()
    %{lesson: lesson}
  end
end
