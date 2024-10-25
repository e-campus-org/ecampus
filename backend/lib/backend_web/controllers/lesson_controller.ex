defmodule BackendWeb.LessonController do
  use BackendWeb, :controller

  alias Backend.Lessons
  alias Backend.Lessons.Lesson

  import Backend.Auth.Plugs

  action_fallback(BackendWeb.FallbackController)

  plug(:is_teacher)

  def index(conn, %{"page" => _page, "page_size" => _page_size} = params) do
    data = Lessons.list_lessons(params)
    render(conn, :index, data: data)
  end

  def index(conn, _params) do
    data = Lessons.list_lessons(%{"page" => 1, "page_size" => 10})
    render(conn, :index, data: data)
  end

  def create(conn, %{"lesson" => lesson_params}) do
    with {:ok, %Lesson{} = lesson} <- Lessons.create_lesson(lesson_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/lessons/#{lesson}")
      |> render(:show, lesson: lesson)
    end
  end

  def show(conn, %{"id" => id}) do
    lesson = Lessons.get_lesson!(id)
    render(conn, :show, lesson: lesson)
  end

  def update(conn, %{"id" => id, "lesson" => lesson_params}) do
    lesson = Lessons.get_lesson!(id)

    with {:ok, %Lesson{} = lesson} <- Lessons.update_lesson(lesson, lesson_params) do
      render(conn, :show, lesson: lesson)
    end
  end

  def delete(conn, %{"id" => id}) do
    lesson = Lessons.get_lesson!(id)

    with {:ok, %Lesson{}} <- Lessons.delete_lesson(lesson) do
      send_resp(conn, :no_content, "")
    end
  end
end
