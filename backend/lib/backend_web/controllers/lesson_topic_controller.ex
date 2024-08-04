defmodule BackendWeb.LessonTopicController do
  use BackendWeb, :controller

  use PhoenixSwagger

  alias Backend.LessonTopics
  alias Backend.LessonTopics.LessonTopic

  import Backend.Auth.Plugs

  action_fallback(BackendWeb.FallbackController)

  plug(:is_teacher when action in [:create, :update, :delete])

  def swagger_definitions do
    %{
      LessonTopic:
        swagger_schema do
          title("LessonTopic")
          description("A single lesson topic to study")

          properties do
            id(:number, "Unique identifier")
            title(:string, "Lesson topic title")
            description(:string, "Lesson topic description")
            objectives(:string, "Lesson topic objectives")
            content(:boolean, "Lesson topic content")
            lesson_id(:number, "Id of the lesson this topic belongs to")
            inserted_at(:datetime, "Date and time of lesson topic creation")
            updated_at(:datetime, "Date and time of lesson topic last update")
          end

          example(%{
            id: 1,
            title: "Lesson Title",
            description: "Lorem ipsum dolor sit amet",
            objectives: "Lesson Objectives",
            content: "Lorem ipsum dolor sit amet",
            lesson_id: 1,
            inserted_at: "2024-07-11T05:47:50Z",
            updated_at: "2024-07-11T05:47:50Z"
          })
        end,
      LessonTopics:
        swagger_schema do
          title("List of lesson topics")
          description("A collection of LessonTopic")
          type(:array)
          items(Schema.ref(:LessonTopic))
        end,
      Pagination:
        swagger_schema do
          title("Pagination data")
          description("Pagination data to get lesson topics by pages")

          properties do
            count(:number, "Total lesson topics in the database")
            page(:number, "Current page")
            pages(:number, "Total pages")
            page_size(:number, "Page size, i.e. lesson topic count per page")
          end

          example(%{
            count: 10,
            page: 1,
            pages: 2,
            page_size: 5
          })
        end,
      LessonTopicsWithPagination:
        swagger_schema do
          title("List of lesson topics with pagination data")
          description("A collection of LessonTopic with pagination data")

          properties do
            list(Schema.ref(:LessonTopics), "LessonTopics list", required: true)
            pagination(Schema.ref(:Pagination), "Pagination data", required: true)
          end
        end,
      NewLessonTopic:
        swagger_schema do
          title("New lesson")
          description("Data object to create new lesson")

          properties do
            title(:string, "Lesson topic title", required: true)
            description(:string, "Lesson topic description")
            objectives(:string, "Lesson topic objectives")
            content(:boolean, "Lesson topic content")
            lesson_id(:number, "Id of the lesson this topic belongs to", required: true)
          end

          example(%{
            title: "Lesson Title",
            description: "Lorem ipsum dolor sit amet",
            objectives: "Lesson Objectives",
            content: "Lorem ipsum dolor sit amet",
            lesson_id: 1
          })
        end,
      UpdateLessonTopic:
        swagger_schema do
          title("Update existing lesson topic")
          description("Data object to update lesson topic")

          properties do
            title(:string, "Lesson topic title")
            description(:string, "Lesson topic description")
            objectives(:string, "Lesson topic objectives")
            content(:boolean, "Lesson topic content")
            lesson_id(:number, "Id of the lesson this topic belongs to")
          end

          example(%{
            title: "Lesson Title",
            description: "Lorem ipsum dolor sit amet",
            objectives: "Lesson Objectives",
            content: "Lorem ipsum dolor sit amet",
            lesson_id: 1
          })
        end
    }
  end

  swagger_path :index do
    get("/lesson_topics")
    summary("Query for lesson topics")
    description("Query for all lesson topics. This operation supports pagination.")
    produces("application/json")
    tag("LessonTopics")

    security([%{bearer: []}])

    response(200, "Success", Schema.ref(:LessonTopicsWithPagination))
  end

  def index(conn, %{"page" => _page, "page_size" => _page_size} = params) do
    data = LessonTopics.list_lesson_topics(params)
    render(conn, :index, data: data)
  end

  def index(conn, _params) do
    data = LessonTopics.list_lesson_topics(%{"page" => 1, "page_size" => 10})
    render(conn, :index, data: data)
  end

  swagger_path :create do
    post("/lesson_topics")
    summary("Create new lesson topic")
    description("Create new lesson topic.")
    produces("application/json")
    tag("LessonTopics")

    security([%{bearer: []}])

    parameters do
      lesson_topic(:body, Schema.ref(:NewLessonTopic), "Data to create lesson topic",
        required: true
      )
    end

    response(201, "Success", Schema.ref(:LessonTopic))
    response(422, "Unprocessable entity (something wrong with body)")
    response(400, "Bad request (Unknown error)")
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

  swagger_path :show do
    get("/lesson_topics/{id}")
    summary("Query single lesson topic by id")
    description("Query single lesson topic by id.")
    produces("application/json")
    tag("LessonTopics")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Lesson topic id", required: true)
    end

    response(200, "Success", Schema.ref(:LessonTopic))
    response(404, "Not found (lesson topic doesn't exists)")
    response(400, "Bad request (Unknown error)")
  end

  def show(conn, %{"id" => id}) do
    lesson_topic = LessonTopics.get_lesson_topic!(id)
    render(conn, :show, lesson_topic: lesson_topic)
  end

  swagger_path :update do
    put("/lesson_topics/{id}")
    summary("Update existing lesson topic")
    description("Update existing lesson topic.")
    produces("application/json")
    tag("LessonTopics")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Lesson topic id", required: true)

      lesson_topic(:body, Schema.ref(:UpdateLesson), "Data to update lesson topic",
        required: true
      )
    end

    response(200, "Success", Schema.ref(:Lesson))
    response(404, "Not found (lesson topic doesn't exists)")
    response(422, "Unprocessable entity (something wrong with body)")
    response(400, "Bad request (Unknown error)")
  end

  def update(conn, %{"id" => id, "lesson_topic" => lesson_topic_params}) do
    lesson_topic = LessonTopics.get_lesson_topic!(id)

    with {:ok, %LessonTopic{} = lesson_topic} <-
           LessonTopics.update_lesson_topic(lesson_topic, lesson_topic_params) do
      render(conn, :show, lesson_topic: lesson_topic)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/lesson_topics/{id}")
    summary("Delete lesson topic by id")
    description("Delete lesson topic by id.")
    tag("LessonTopics")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Lesson topic id", required: true)
    end

    response(204, "No content (lesson topic deleted)")
    response(404, "Not found (lesson topic doesn't exists)")
    response(400, "Bad request (Unknown error)")
  end

  def delete(conn, %{"id" => id}) do
    lesson_topic = LessonTopics.get_lesson_topic!(id)

    with {:ok, %LessonTopic{}} <- LessonTopics.delete_lesson_topic(lesson_topic) do
      send_resp(conn, :no_content, "")
    end
  end
end
