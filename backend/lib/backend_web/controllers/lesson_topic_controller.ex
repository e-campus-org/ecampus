defmodule BackendWeb.LessonTopicController do
  use BackendWeb, :controller

  alias Backend.LessonTopics
  alias Backend.LessonTopics.LessonTopic

  import Backend.Auth.Plugs

  action_fallback(BackendWeb.FallbackController)

  plug(:teacher?)

  def index(conn, %{"page" => _page, "page_size" => _page_size} = params) do
    data = LessonTopics.list_lesson_topics(params)
    render(conn, :index, data: data)
  end

  def index(conn, _params) do
    data = LessonTopics.list_lesson_topics(%{"page" => 1, "page_size" => 10})
    render(conn, :index, data: data)
  end

  def create(conn, %{"lesson_topic" => lesson_topic_params}) do
    with {:ok, %LessonTopic{} = lesson_topic} <-
           LessonTopics.create_lesson_topic(lesson_topic_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/lesson_topics/#{lesson_topic}")
      |> render(:show, lesson_topic: lesson_topic)
    end
  end

  def show(conn, %{"id" => id}) do
    lesson_topic = LessonTopics.get_lesson_topic!(id)
    render(conn, :show, lesson_topic: lesson_topic)
  end

  def update(conn, %{"id" => id, "lesson_topic" => lesson_topic_params}) do
    lesson_topic = LessonTopics.get_lesson_topic!(id)

    with {:ok, %LessonTopic{} = lesson_topic} <-
           LessonTopics.update_lesson_topic(lesson_topic, lesson_topic_params) do
      render(conn, :show, lesson_topic: lesson_topic)
    end
  end

  def delete(conn, %{"id" => id}) do
    lesson_topic = LessonTopics.get_lesson_topic!(id)

    with {:ok, %LessonTopic{}} <- LessonTopics.delete_lesson_topic(lesson_topic) do
      send_resp(conn, :no_content, "")
    end
  end
end
