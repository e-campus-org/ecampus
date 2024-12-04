defmodule BackendWeb.LessonControllerTest do
  use BackendWeb.ConnCase

  import Backend.Auth.Guardian

  import Backend.LessonsFixtures

  import Backend.SubjectsFixtures

  @create_attrs %{
    title: "some title",
    topic: "some topic",
    is_draft: true,
    subject_id: nil
  }
  @update_attrs %{
    title: "some updated title",
    topic: "some updated topic",
    is_draft: false,
    subject_id: nil
  }
  @invalid_attrs %{title: nil, topic: nil, is_draft: nil, subject_id: nil}

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
    test "lists all lessons", %{conn: conn} do
      conn = get(conn, ~p"/api/lessons")
      assert json_response(conn, 200)["list"] == []
    end
  end

  describe "create lesson" do
    setup [:create_subject]

    test "renders lesson when data is valid", %{conn: conn, subject: %{id: subject_id}} do
      conn = post(conn, ~p"/api/lessons", lesson: %{@create_attrs | subject_id: subject_id})
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, ~p"/api/lessons/#{id}")

      expected_is_draft = @create_attrs.is_draft
      expected_title = @create_attrs.title
      expected_topic = @create_attrs.topic

      assert %{
               "id" => ^id,
               "is_draft" => ^expected_is_draft,
               "title" => ^expected_title,
               "topic" => ^expected_topic,
               "subject_id" => ^subject_id
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/lessons", lesson: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update lesson" do
    setup [:create_lesson, :create_subject]

    test "renders lesson when data is valid", %{
      conn: conn,
      lesson: %{id: id},
      subject: %{id: subject_id}
    } do
      conn =
        put(conn, ~p"/api/lessons/#{id}", lesson: %{@update_attrs | subject_id: subject_id})

      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/api/lessons/#{id}")

      expected_is_draft = @update_attrs.is_draft
      expected_title = @update_attrs.title
      expected_topic = @update_attrs.topic

      assert %{
               "id" => ^id,
               "is_draft" => ^expected_is_draft,
               "title" => ^expected_title,
               "topic" => ^expected_topic,
               "subject_id" => ^subject_id
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      lesson: lesson
    } do
      conn =
        put(conn, ~p"/api/lessons/#{lesson}", lesson: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete lesson" do
    setup [:create_lesson]

    test "deletes chosen lesson", %{conn: conn, lesson: lesson} do
      conn = delete(conn, ~p"/api/lessons/#{lesson}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/lessons/#{lesson}")
      end
    end
  end

  defp create_subject(_) do
    subject = subject_fixture()
    %{subject: subject}
  end

  defp create_lesson(_) do
    subject = subject_fixture()
    lesson = lesson_fixture(%{subject_id: subject.id})
    %{lesson: lesson}
  end
end
