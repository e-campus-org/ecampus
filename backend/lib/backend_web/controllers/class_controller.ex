defmodule BackendWeb.ClassController do
  use BackendWeb, :controller

  use PhoenixSwagger

  alias Backend.Classes
  alias Backend.Classes.Class

  import Backend.Auth.Plugs

  action_fallback(BackendWeb.FallbackController)

  plug(:is_teacher when action in [:create, :update, :delete])

  def swagger_definitions do
    %{
      ClassLesson:
        swagger_schema do
          title("ClassLesson")
          description("A lesson object inside class object")

          properties do
            id(:number, "Unique identifier")
            title(:string, "Lesson title")
            topic(:string, "Lesson topic")
            hours_count(:number, "Academic hours for this lesson")
            subject_id(:number, "Subject id")
          end

          example(%{
            id: 1,
            title: "Lorem ipsum dolor sit amet",
            topic: "Lorem ipsum dolor sit amet",
            hours_count: 2,
            subject_id: 1
          })
        end,
      ClassGroup:
        swagger_schema do
          title("ClassGroup")
          description("A group object inside class object")

          properties do
            id(:number, "Unique identifier")
            title(:string, "Group title")
          end

          example(%{
            id: 1,
            title: "123a"
          })
        end,
      Class:
        swagger_schema do
          title("Class")
          description("A current class with lesson and group")

          properties do
            id(:number, "Unique identifier")
            begin_date(:datetime, "Class begin date and time")
            classroom(:string, "Classroom number")
            lesson(Schema.ref(:ClassLesson), "Class lesson info")
            group(Schema.ref(:ClassGroup), "Class group info")
            inserted_at(:datetime, "Date and time of class creation")
            updated_at(:datetime, "Date and time of class last update")
          end

          example(%{
            id: 1,
            begin_date: "2024-07-11T10:00:00Z",
            classroom: "103a",
            lesson: %{
              id: 1,
              title: "Lorem ipsum dolor sit amet",
              topic: "Lorem ipsum dolor sit amet",
              hours_count: 2,
              subject_id: 1
            },
            group: %{
              id: 1,
              title: "123a"
            },
            inserted_at: "2024-07-11T05:47:50Z",
            updated_at: "2024-07-11T05:47:50Z"
          })
        end,
      Classes:
        swagger_schema do
          title("List of classes")
          description("A collection of Class")
          type(:array)
          items(Schema.ref(:Class))
        end,
      Pagination:
        swagger_schema do
          title("Pagination data")
          description("Pagination data to get classes by pages")

          properties do
            count(:number, "Total classes in the database")
            page(:number, "Current page")
            pages(:number, "Total pages")
            page_size(:number, "Page size, i.e. class count per page")
          end

          example(%{
            count: 10,
            page: 1,
            pages: 2,
            page_size: 5
          })
        end,
      ClassesWithPagination:
        swagger_schema do
          title("List of classes with pagination data")
          description("A collection of Classes with pagination data")

          properties do
            list(Schema.ref(:Classes), "Classes list", required: true)
            pagination(Schema.ref(:Pagination), "Pagination data", required: true)
          end
        end,
      NewClass:
        swagger_schema do
          title("New class")
          description("Data object to create new class")

          properties do
            begin_date(:datetime, "Class begin date and time", required: true)
            classroom(:string, "Classroom number", required: true)
            lesson_id(:string, "Id of the lesson this class is for", required: true)
            group_id(:number, "Id of the group this class is for", required: true)
          end

          example(%{
            begin_date: "2024-07-11T10:00:00Z",
            classroom: "103a",
            lesson_id: 1,
            group_id: 1
          })
        end,
      UpdateClass:
        swagger_schema do
          title("Update existing lesson")
          description("Data object to update lesson")

          properties do
            begin_date(:datetime, "Class begin date and time")
            classroom(:string, "Classroom number")
            lesson_id(:string, "Id of the lesson this class is for")
            group_id(:number, "Id of the group this class is for")
          end

          example(%{
            begin_date: "2024-07-11T10:00:00Z",
            classroom: "103a",
            lesson_id: 1,
            group_id: 1
          })
        end
    }
  end

  swagger_path :index do
    get("/classes")
    summary("Query for classes")
    description("Query for all classes. This operation supports pagination.")
    produces("application/json")
    tag("Classes")

    parameters do
      page(:query, :number, "Page")
      page_size(:query, :number, "Page size")
      group_id(:query, :number, "Group id")
      lesson_id(:query, :string, "Lesson id")
      classroom(:query, :string, "Classroom number")
      begin_date(:query, :string, "Class begin date")
    end

    security([%{bearer: []}])

    response(200, "Success", Schema.ref(:ClassesWithPagination))
  end

  def index(conn, params) do
    data = Classes.list_classes(params)
    render(conn, :index, data: data)
  end

  swagger_path :create do
    post("/classes")
    summary("Create new class")
    description("Create new class.")
    produces("application/json")
    tag("Classes")

    security([%{bearer: []}])

    parameters do
      class(:body, Schema.ref(:NewClass), "Data to create class", required: true)
    end

    response(201, "Success", Schema.ref(:Class))
    response(422, "Unprocessable entity (something wrong with body)")
    response(400, "Bad request (Unknown error)")
  end

  def create(conn, %{"class" => class_params}) do
    with {:ok, %Class{} = class} <- Classes.create_class(class_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/classes/#{class}")
      |> render(:show, class: class)
    end
  end

  swagger_path :show do
    get("/classes/{id}")
    summary("Query single class by id")
    description("Query single class by id.")
    produces("application/json")
    tag("Classes")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Class id", required: true)
    end

    response(200, "Success", Schema.ref(:Class))
    response(404, "Not found (class doesn't exists)")
    response(400, "Bad request (Unknown error)")
  end

  def show(conn, %{"id" => id}) do
    class = Classes.get_class!(id)
    render(conn, :show, class: class)
  end

  swagger_path :update do
    put("/classes/{id}")
    summary("Update existing class")
    description("Update existing class.")
    produces("application/json")
    tag("Classes")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Class id", required: true)
      class(:body, Schema.ref(:UpdateClass), "Data to update class", required: true)
    end

    response(200, "Success", Schema.ref(:Class))
    response(404, "Not found (class doesn't exists)")
    response(422, "Unprocessable entity (something wrong with body)")
    response(400, "Bad request (Unknown error)")
  end

  def update(conn, %{"id" => id, "class" => class_params}) do
    class = Classes.get_class!(id)

    with {:ok, %Class{} = class} <- Classes.update_class(class, class_params) do
      render(conn, :show, class: class)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/classes/{id}")
    summary("Delete class by id")
    description("Delete class by id.")
    tag("Classes")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Class id", required: true)
    end

    response(204, "No content (class deleted)")
    response(404, "Not found (class doesn't exists)")
    response(400, "Bad request (Unknown error)")
  end

  def delete(conn, %{"id" => id}) do
    class = Classes.get_class!(id)

    with {:ok, %Class{}} <- Classes.delete_class(class) do
      send_resp(conn, :no_content, "")
    end
  end
end
