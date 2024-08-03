defmodule BackendWeb.LessonController do
  use BackendWeb, :controller

  use PhoenixSwagger

  alias Backend.Lessons
  alias Backend.Lessons.Lesson

  import Backend.Auth.Plugs

  action_fallback(BackendWeb.FallbackController)

  plug(:is_teacher when action in [:create, :update, :delete])

  def swagger_definitions do
    %{
      Lesson:
        swagger_schema do
          title("Lesson")
          description("A single lesson of lesson to study")

          properties do
            id(:number, "Unique identifier")
            title(:string, "Lesson title")
            description(:string, "Lesson description")
            topic(:string, "Lesson topic")
            is_draft(:boolean, "Is lesson draft (not shown to students)")
            subject_id(:number, "Id of the subject this lesson belongs to")
            inserted_at(:datetime, "Date and time of lesson creation")
            updated_at(:datetime, "Date and time of lesson last update")
          end

          example(%{
            id: 1,
            title: "Lesson Title",
            description: "Lorem ipsum dolor sit amet",
            topic: "Lesson Topic",
            is_draft: false,
            subject_id: 1,
            inserted_at: "2024-07-11T05:47:50Z",
            updated_at: "2024-07-11T05:47:50Z"
          })
        end,
      Lessons:
        swagger_schema do
          title("List of lessons")
          description("A collection of Lesson")
          type(:array)
          items(Schema.ref(:Lesson))
        end,
      Pagination:
        swagger_schema do
          title("Pagination data")
          description("Pagination data to get lessons by pages")

          properties do
            count(:number, "Total lessons in the database")
            page(:number, "Current page")
            pages(:number, "Total pages")
            page_size(:number, "Page size, i.e. lesson count per page")
          end

          example(%{
            count: 10,
            page: 1,
            pages: 2,
            page_size: 5
          })
        end,
      LessonsWithPagination:
        swagger_schema do
          title("List of lessons with pagination data")
          description("A collection of Lesson with pagination data")

          properties do
            list(Schema.ref(:Lessons), "Lessons list", required: true)
            pagination(Schema.ref(:Pagination), "Pagination data", required: true)
          end
        end,
      NewLesson:
        swagger_schema do
          title("New lesson")
          description("Data object to create new lesson")

          properties do
            title(:string, "Lesson title", required: true)
            description(:string, "Lesson description")
            topic(:string, "Lesson topic", required: true)
            is_draft(:boolean, "Is lesson draft (not shown to students)")
            subject_id(:number, "Id of the subject this lesson belongs to", required: true)
          end

          example(%{
            title: "Lesson Title",
            description: "Lorem ipsum dolor sit amet",
            topic: "Lesson Topic",
            is_draft: false,
            subject_id: 1
          })
        end,
      UpdateLesson:
        swagger_schema do
          title("Update existing lesson")
          description("Data object to update lesson")

          properties do
            title(:string, "Lesson title")
            description(:string, "Lesson description")
            topic(:string, "Lesson topic")
            is_draft(:boolean, "Is lesson draft (not shown to students)")
            subject_id(:number, "Id of the subject this lesson belongs to")
          end

          example(%{
            title: "Lesson Title",
            description: "Lorem ipsum dolor sit amet",
            topic: "Lesson Topic",
            is_draft: false,
            subject_id: 1
          })
        end
    }
  end

  swagger_path :index do
    get("/lessons")
    summary("Query for lessons")
    description("Query for all lessons. This operation supports pagination.")
    produces("application/json")
    tag("Lessons")

    security([%{bearer: []}])

    response(200, "Success", Schema.ref(:LessonsWithPagination))
  end

  def index(conn, %{"page" => _page, "page_size" => _page_size} = params) do
    data = Lessons.list_lessons(params)
    render(conn, :index, data: data)
  end

  def index(conn, _params) do
    data = Lessons.list_lessons(%{"page" => 1, "page_size" => 10})
    render(conn, :index, data: data)
  end

  swagger_path :create do
    post("/lessons")
    summary("Create new lesson")
    description("Create new lesson.")
    produces("application/json")
    tag("Lessons")

    security([%{bearer: []}])

    parameters do
      lesson(:body, Schema.ref(:NewLesson), "Data to create lesson", required: true)
    end

    response(201, "Success", Schema.ref(:Lesson))
    response(422, "Unprocessable entity (something wrong with body)")
    response(400, "Bad request (Unknown error)")
  end

  def create(conn, %{"lesson" => lesson_params}) do
    with {:ok, %Lesson{} = lesson} <- Lessons.create_lesson(lesson_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/lessons/#{lesson}")
      |> render(:show, lesson: lesson)
    end
  end

  swagger_path :show do
    get("/lessons/{id}")
    summary("Query single lesson by id")
    description("Query single lesson by id.")
    produces("application/json")
    tag("Lessons")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Lesson id", required: true)
    end

    response(200, "Success", Schema.ref(:Lesson))
    response(404, "Not found (lesson doesn't exists)")
    response(400, "Bad request (Unknown error)")
  end

  def show(conn, %{"id" => id}) do
    lesson = Lessons.get_lesson!(id)
    render(conn, :show, lesson: lesson)
  end

  swagger_path :update do
    put("/lessons/{id}")
    summary("Update existing lesson")
    description("Update existing lesson.")
    produces("application/json")
    tag("Lessons")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Lesson id", required: true)
      lesson(:body, Schema.ref(:UpdateLesson), "Data to update lesson", required: true)
    end

    response(200, "Success", Schema.ref(:Lesson))
    response(404, "Not found (lesson doesn't exists)")
    response(422, "Unprocessable entity (something wrong with body)")
    response(400, "Bad request (Unknown error)")
  end

  def update(conn, %{"id" => id, "lesson" => lesson_params}) do
    lesson = Lessons.get_lesson!(id)

    with {:ok, %Lesson{} = lesson} <- Lessons.update_lesson(lesson, lesson_params) do
      render(conn, :show, lesson: lesson)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/lessons/{id}")
    summary("Delete lesson by id")
    description("Delete lesson by id.")
    tag("Lessons")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Lesson id", required: true)
    end

    response(204, "No content (lesson deleted)")
    response(404, "Not found (lesson doesn't exists)")
    response(400, "Bad request (Unknown error)")
  end

  def delete(conn, %{"id" => id}) do
    lesson = Lessons.get_lesson!(id)

    with {:ok, %Lesson{}} <- Lessons.delete_lesson(lesson) do
      send_resp(conn, :no_content, "")
    end
  end
end
