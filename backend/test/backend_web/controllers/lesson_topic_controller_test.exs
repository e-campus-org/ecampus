defmodule BackendWeb.LessonTopicControllerTest do
  use BackendWeb.ConnCase

  import Backend.Auth.Guardian

  import Backend.LessonsFixtures

  import Backend.SubjectsFixtures

  import Backend.LessonTopicsFixtures

  @create_attrs %{
    title: "some title",
    content: %{},
    lesson_id: nil
  }
  @update_attrs %{
    title: "some updated title",
    content: %{"test" => "value"},
    lesson_id: nil
  }
  @invalid_attrs %{title: nil, content: nil, lesson_id: nil}

  @teacher_account %{
    id: 1,
    first_name: "John",
    last_name: "Doe",
    email: "admin@ecampus.com",
    password: "qwerty",
    password_confirmation: "qwerty",
    roles: [:teacher]
  }

  setup %{conn: conn} do
    {:ok, _, token} = create_token(@teacher_account)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{token}")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all lesson_topics", %{conn: conn} do
      conn = get(conn, ~p"/api/lesson_topics")
      assert json_response(conn, 200)["list"] == []
    end
  end

  describe "create lesson_topic" do
    setup [:create_lesson]

    test "renders lesson_topic when data is valid", %{conn: conn, lesson: %{id: lesson_id}} do
      conn =
        post(conn, ~p"/api/lesson_topics", lesson_topic: %{@create_attrs | lesson_id: lesson_id})

      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, ~p"/api/lesson_topics/#{id}")

      expected_content = @create_attrs.content
      expected_title = @create_attrs.title

      assert %{
               "id" => ^id,
               "content" => ^expected_content,
               "title" => ^expected_title,
               "lesson_id" => ^lesson_id
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/lesson_topics", lesson_topic: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update lesson_topic" do
    setup [:create_lesson, :create_lesson_topic]

    test "renders lesson_topic when data is valid", %{
      conn: conn,
      lesson: %{id: lesson_id},
      lesson_topic: %{id: id}
    } do
      conn =
        put(conn, ~p"/api/lesson_topics/#{id}",
          lesson_topic: %{@update_attrs | lesson_id: lesson_id}
        )

      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/api/lesson_topics/#{id}")

      expected_content = @update_attrs.content
      expected_title = @update_attrs.title

      assert %{
               "id" => ^id,
               "content" => ^expected_content,
               "title" => ^expected_title
             } = json_response(conn, 200)
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

  defp create_lesson(_) do
    subject = subject_fixture()
    lesson = lesson_fixture(%{subject_id: subject.id})
    %{lesson: lesson}
  end

  defp create_lesson_topic(_) do
    subject = subject_fixture()
    lesson = lesson_fixture(%{subject_id: subject.id})
    lesson_topic = lesson_topic_fixture(%{lesson_id: lesson.id})
    %{lesson_topic: lesson_topic}
  end
end
