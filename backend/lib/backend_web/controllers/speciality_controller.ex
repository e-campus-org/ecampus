defmodule BackendWeb.SpecialityController do
  use BackendWeb, :controller

  use PhoenixSwagger

  alias Backend.Specialities
  alias Backend.Specialities.Speciality

  import Backend.Auth.Plugs

  action_fallback(BackendWeb.FallbackController)

  plug(:is_admin when action in [:create, :update, :delete])

  def swagger_definitions do
    %{
      Speciality:
        swagger_schema do
          title("Speciality")
          description("A student speciality")

          properties do
            id(:number, "Unique identifier")
            title(:title, "Speciality title")
            description(:string, "Speciality description")
            code(:string, "Speciality code")
            inserted_at(:datetime, "Date and time of speciality creation")
            updated_at(:datetime, "Date and time of speciality last update")
          end

          example(%{
            id: 1,
            title: "Speciality A",
            description: "Lorem ipsum dolor sit amet",
            code: "01.01.01",
            inserted_at: "2024-07-11T05:47:50Z",
            updated_at: "2024-07-11T05:47:50Z"
          })
        end,
      Specialities:
        swagger_schema do
          title("List of specialities")
          description("A collection of Speciality")
          type(:array)
          items(Schema.ref(:Speciality))
        end,
      Pagination:
        swagger_schema do
          title("Pagination data")
          description("Pagination data to get specialities by pages")

          properties do
            count(:number, "Total specialities in the database")
            page(:number, "Current page")
            pages(:number, "Total pages")
            page_size(:number, "Page size, i.e. specialities count per page")
          end

          example(%{
            count: 10,
            page: 1,
            pages: 2,
            page_size: 5
          })
        end,
      SpecialitiesWithPagination:
        swagger_schema do
          title("List of specialities with pagination data")
          description("A collection of Speciality with pagination data")

          properties do
            list(Schema.ref(:Specialities), "Specialities list", required: true)
            pagination(Schema.ref(:Pagination), "Pagination data", required: true)
          end
        end,
      NewSpeciality:
        swagger_schema do
          title("New speciality")
          description("Data object to create new speciality")

          properties do
            title(:string, "Speciality title", required: true)
            description(:string, "Speciality description", required: true)
            code(:string, "Speciality code", required: true)
          end

          example(%{
            title: "Speciality A",
            description: "Lorem ipsum dolor sit amet",
            code: "01.01.01"
          })
        end,
      UpdateSpeciality:
        swagger_schema do
          title("Update existing speciality")
          description("Data object to update speciality")

          properties do
            title(:string, "Speciality title")
            description(:string, "Speciality description")
            code(:string, "Speciality code")
          end

          example(%{
            title: "Speciality A",
            description: "Lorem ipsum dolor sit amet",
            code: "01.01.01"
          })
        end
    }
  end

  swagger_path :index do
    get("/specialities")
    summary("Query for specialities")
    description("Query for all specialities. This operation supports pagination.")
    produces("application/json")
    tag("Specialities")

    parameters do
      page(:query, :number, "Page")
      page_size(:query, :number, "Page size")
    end

    security([%{bearer: []}])

    response(200, "Success", Schema.ref(:SpecialitiesWithPagination))
  end

  def index(conn, %{"page" => _page, "page_size" => _page_size} = params) do
    data = Specialities.list_specialities(params)
    render(conn, :index, data: data)
  end

  def index(conn, _params) do
    data = Specialities.list_specialities(%{"page" => 1, "page_size" => 10})
    render(conn, :index, data: data)
  end

  swagger_path :create do
    post("/specialities")
    summary("Create new speciality")
    description("Create new speciality.")
    produces("application/json")
    tag("Specialities")

    security([%{bearer: []}])

    parameters do
      speciality(:body, Schema.ref(:NewSpeciality), "Data to create speciality", required: true)
    end

    response(201, "Success", Schema.ref(:Speciality))
    response(422, "Unprocessable entity (something wrong with body)")
    response(400, "Bad request (Unknown error)")
  end

  def create(conn, %{"speciality" => speciality_params}) do
    with {:ok, %Speciality{} = speciality} <- Specialities.create_speciality(speciality_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/specialities/#{speciality}")
      |> render(:show, speciality: speciality)
    end
  end

  swagger_path :show do
    get("/specialities/{id}")
    summary("Query single speciality by id")
    description("Query single speciality by id.")
    produces("application/json")
    tag("Specialities")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Speciality id", required: true)
    end

    response(200, "Success", Schema.ref(:Speciality))
    response(404, "Not found (spiciality doesn't exists)")
    response(400, "Bad request (Unknown error)")
  end

  def show(conn, %{"id" => id}) do
    speciality = Specialities.get_speciality!(id)
    render(conn, :show, speciality: speciality)
  end

  swagger_path :update do
    put("/specialities/{id}")
    summary("Update existing speciality")
    description("Update existing speciality.")
    produces("application/json")
    tag("Specialities")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Speciality id", required: true)

      speciality(:body, Schema.ref(:UpdateSpeciality), "Data to update speciality",
        required: true
      )
    end

    response(200, "Success", Schema.ref(:Speciality))
    response(404, "Not found (speciality doesn't exists)")
    response(422, "Unprocessable entity (something wrong with body)")
    response(400, "Bad request (Unknown error)")
  end

  def update(conn, %{"id" => id, "speciality" => speciality_params}) do
    speciality = Specialities.get_speciality!(id)

    with {:ok, %Speciality{} = speciality} <-
           Specialities.update_speciality(speciality, speciality_params) do
      render(conn, :show, speciality: speciality)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/specialities/{id}")
    summary("Delete speciality by id")
    description("Delete speciality by id.")
    tag("Specialities")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Speciality id", required: true)
    end

    response(204, "No content (speciality deleted)")
    response(404, "Not found (speciality doesn't exists)")
    response(400, "Bad request (Unknown error)")
  end

  def delete(conn, %{"id" => id}) do
    speciality = Specialities.get_speciality!(id)

    with {:ok, %Speciality{}} <- Specialities.delete_speciality(speciality) do
      send_resp(conn, :no_content, "")
    end
  end
end
