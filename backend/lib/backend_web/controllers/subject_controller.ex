defmodule BackendWeb.SubjectController do
  use BackendWeb, :controller

  use PhoenixSwagger

  alias Backend.Subjects
  alias Backend.Subjects.Subject

  import Backend.Auth.Plugs

  action_fallback BackendWeb.FallbackController

  plug(:is_teacher when action in [:create, :update, :delete])

  def swagger_definitions do
    %{
      Subject:
        swagger_schema do
          title("Subject")
          description("A subject to study")

          properties do
            id(:number, "Unique identifier")
            title(:string, "Subject title")
            short_title(:string, "Subject short title")
            description(:string, "Subject description")
            prerequisites(:string, "Subject prerequisites")
            objectives(:string, "Subject objectives")
            required_texts(:string, "Subject required texts")
            inserted_at(:datetime, "Date and time of subject creation")
            updated_at(:datetime, "Date and time of subject last update")
          end

          example(%{
            id: 1,
            title: "Subject Title",
            short_title: "ST",
            description: "Lorem ipsum dolor sit amet",
            prerequisites: "Subj1, Subj2",
            objectives: "Lorem ipsum dolor sit amet",
            required_texts: "Lorem ipsum dolor sit amet",
            inserted_at: "2024-07-11T05:47:50Z",
            updated_at: "2024-07-11T05:47:50Z"
          })
        end,
      Subjects:
        swagger_schema do
          title("List of subjects")
          description("A collection of Subject")
          type(:array)
          items(Schema.ref(:Subject))
        end,
      Pagination:
        swagger_schema do
          title("Pagination data")
          description("Pagination data to get subjects by pages")

          properties do
            count(:number, "Total subjects in the database")
            page(:number, "Current page")
            pages(:number, "Total pages")
            page_size(:number, "Page size, i.e. group count per page")
          end

          example(%{
            count: 10,
            page: 1,
            pages: 2,
            page_size: 5
          })
        end,
      SubjectsWithPagination:
        swagger_schema do
          title("List of subjects with pagination data")
          description("A collection of Subject with pagination data")

          properties do
            list(Schema.ref(:Subjects), "Subjects list", required: true)
            pagination(Schema.ref(:Pagination), "Pagination data", required: true)
          end
        end,
      NewSubject:
        swagger_schema do
          title("New subject")
          description("Data object to create new subject")

          properties do
            title(:string, "Subject title", required: true)
            short_title(:string, "Subject short title", required: true)
            description(:string, "Subject description")
            prerequisites(:string, "Subject prerequisites")
            objectives(:string, "Subject objectives")
            required_texts(:string, "Subject required texts")
          end

          example(%{
            title: "Subject Title",
            short_title: "ST",
            description: "Lorem ipsum dolor sit amet",
            prerequisites: "Subj1, Subj2",
            objectives: "Lorem ipsum dolor sit amet",
            required_texts: "Lorem ipsum dolor sit amet"
          })
        end,
      UpdateSubject:
        swagger_schema do
          title("Update existing subject")
          description("Data object to update subject")

          properties do
            title(:string, "Subject title")
            short_title(:string, "Subject short title")
            description(:string, "Subject description")
            prerequisites(:string, "Subject prerequisites")
            objectives(:string, "Subject objectives")
            required_texts(:string, "Subject required texts")
          end

          example(%{
            title: "Subject Title",
            short_title: "ST",
            description: "Lorem ipsum dolor sit amet",
            prerequisites: "Subj1, Subj2",
            objectives: "Lorem ipsum dolor sit amet",
            required_texts: "Lorem ipsum dolor sit amet"
          })
        end
    }
  end

  swagger_path :index do
    get("/subjects")
    summary("Query for subjects")
    description("Query for all subjects. This operation supports pagination.")
    produces("application/json")
    tag("Subjects")

    security([%{bearer: []}])

    response(200, "Success", Schema.ref(:SubjectsWithPagination))
  end

  def index(conn, %{"page" => _page, "page_size" => _page_size} = params) do
    data = Subjects.list_subjects(params)
    render(conn, :index, data: data)
  end

  def index(conn, _params) do
    data = Subjects.list_subjects(%{"page" => 1, "page_size" => 10})
    render(conn, :index, data: data)
  end

  swagger_path :create do
    post("/subjects")
    summary("Create new subject")
    description("Create new subject.")
    produces("application/json")
    tag("Subjects")

    security([%{bearer: []}])

    parameters do
      subject(:body, Schema.ref(:NewSubject), "Data to create subject", required: true)
    end

    response(201, "Success", Schema.ref(:Subject))
    response(422, "Unprocessable entity (something wrong with body)")
    response(400, "Bad request (Unknown error)")
  end

  def create(conn, %{"subject" => subject_params}) do
    with {:ok, %Subject{} = subject} <- Subjects.create_subject(subject_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/subjects/#{subject}")
      |> render(:show, subject: subject)
    end
  end

  swagger_path :show do
    get("/subjects/{id}")
    summary("Query single subject by id")
    description("Query single subject by id.")
    produces("application/json")
    tag("Subjects")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Subject id", required: true)
    end

    response(200, "Success", Schema.ref(:Subject))
    response(404, "Not found (subject doesn't exists)")
    response(400, "Bad request (Unknown error)")
  end

  def show(conn, %{"id" => id}) do
    subject = Subjects.get_subject!(id)
    render(conn, :show, subject: subject)
  end

  swagger_path :update do
    put("/subjects/{id}")
    summary("Update existing subject")
    description("Update existing subject.")
    produces("application/json")
    tag("Subjects")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Subject id", required: true)
      subject(:body, Schema.ref(:UpdateSubject), "Data to update subject", required: true)
    end

    response(200, "Success", Schema.ref(:Subject))
    response(404, "Not found (subject doesn't exists)")
    response(422, "Unprocessable entity (something wrong with body)")
    response(400, "Bad request (Unknown error)")
  end

  def update(conn, %{"id" => id, "subject" => subject_params}) do
    subject = Subjects.get_subject!(id)

    with {:ok, %Subject{} = subject} <- Subjects.update_subject(subject, subject_params) do
      render(conn, :show, subject: subject)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/subjects/{id}")
    summary("Delete subject by id")
    description("Delete subject by id.")
    tag("Subjects")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Subject id", required: true)
    end

    response(204, "No content (subject deleted)")
    response(404, "Not found (subject doesn't exists)")
    response(400, "Bad request (Unknown error)")
  end

  def delete(conn, %{"id" => id}) do
    subject = Subjects.get_subject!(id)

    with {:ok, %Subject{}} <- Subjects.delete_subject(subject) do
      send_resp(conn, :no_content, "")
    end
  end
end
