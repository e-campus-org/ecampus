defmodule BackendWeb.LessonTopicControllerTest do
  use BackendWeb.ConnCase

  import Backend.LessonTopicsFixtures

  alias Backend.LessonTopics.LessonTopic

  @create_attrs %{
    title: "some title",
    content: "some content"
  }
  @update_attrs %{
    title: "some updated title",
    content: "some updated content"
  }
  @invalid_attrs %{title: nil, content: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all lesson_topics", %{conn: conn} do
      conn = get(conn, ~p"/api/lesson_topics")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create lesson_topic" do
    test "renders lesson_topic when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/lesson_topics", lesson_topic: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/lesson_topics/#{id}")

      assert %{
               "id" => ^id,
               "content" => "some content",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/lesson_topics", lesson_topic: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update lesson_topic" do
    setup [:create_lesson_topic]

    test "renders lesson_topic when data is valid", %{conn: conn, lesson_topic: %LessonTopic{id: id} = lesson_topic} do
      conn = put(conn, ~p"/api/lesson_topics/#{lesson_topic}", lesson_topic: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/lesson_topics/#{id}")

      assert %{
               "id" => ^id,
               "content" => "some updated content",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, lesson_topic: lesson_topic} do
      conn = put(conn, ~p"/api/lesson_topics/#{lesson_topic}", lesson_topic: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete lesson_topic" do
    setup [:create_lesson_topic]

    test "deletes chosen lesson_topic", %{conn: conn, lesson_topic: lesson_topic} do
      conn = delete(conn, ~p"/api/lesson_topics/#{lesson_topic}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/lesson_topics/#{lesson_topic}")
      end
    end
  end

  defp create_lesson_topic(_) do
    lesson_topic = lesson_topic_fixture()
    %{lesson_topic: lesson_topic}
  end
end
