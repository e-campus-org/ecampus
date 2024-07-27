defmodule BackendWeb.GroupController do
  use BackendWeb, :controller

  use PhoenixSwagger

  alias Backend.Groups
  alias Backend.Groups.Group

  import Backend.Auth.Plugs

  action_fallback BackendWeb.FallbackController

  plug(:is_admin when action in [:create, :update, :delete])

  def swagger_definitions do
    %{
      Group:
        swagger_schema do
          title("Group")
          description("A group of students")

          properties do
            id(:number, "Unique identifier")
            title(:string, "User email")
            description(:string, "User first name")
            speciality_id(:number, "Id od the group speciality")
            inserted_at(:datetime, "Date and time of group creation")
            updated_at(:datetime, "Date and time of group last update")
          end

          example(%{
            id: 1,
            title: "Group number A123",
            description: "Lorem ipsum dolor sit amet",
            speciality_id: 1,
            inserted_at: "2024-07-11T05:47:50Z",
            updated_at: "2024-07-11T05:47:50Z"
          })
        end,
      Groups:
        swagger_schema do
          title("List of groups")
          description("A collection of Group")
          type(:array)
          items(Schema.ref(:Group))
        end,
      Pagination:
        swagger_schema do
          title("Pagination data")
          description("Pagination data to get groups by pages")

          properties do
            count(:number, "Total groups in the database")
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
      GroupsWithPagination:
        swagger_schema do
          title("List of groups with pagination data")
          description("A collection of Group with pagination data")

          properties do
            list(Schema.ref(:Groups), "Groups list", required: true)
            pagination(Schema.ref(:Pagination), "Pagination data", required: true)
          end
        end,
      NewGroup:
        swagger_schema do
          title("New group")
          description("Data object to create new group")

          properties do
            title(:string, "User email", required: true)
            description(:string, "User first name", required: true)
            speciality_id(:number, "Id od the group speciality", required: true)
          end

          example(%{
            title: "Group number A123",
            description: "Lorem ipsum dolor sit amet",
            speciality_id: 1
          })
        end,
      UpdateGroup:
        swagger_schema do
          title("Update existing group")
          description("Data object to update group")

          properties do
            title(:string, "User email", required: true)
            description(:string, "User first name", required: true)
            speciality_id(:number, "Id od the group speciality", required: true)
          end

          example(%{
            title: "Group number A123",
            description: "Lorem ipsum dolor sit amet",
            speciality_id: 1
          })
        end
    }
  end

  swagger_path :index do
    get("/groups")
    summary("Query for groups")
    description("Query for all groups. This operation supports pagination.")
    produces("application/json")
    tag("Groups")

    security([%{bearer: []}])

    response(200, "Success", Schema.ref(:GroupsWithPagination))
  end

  def index(conn, %{"page" => _page, "page_size" => _page_size} = params) do
    data = Groups.list_groups(params)
    render(conn, :index, data: data)
  end

  def index(conn, _params) do
    data = Groups.list_groups(%{"page" => 1, "page_size" => 10})
    render(conn, :index, data: data)
  end

  swagger_path :create do
    post("/groups")
    summary("Create new group")
    description("Create new group.")
    produces("application/json")
    tag("Groups")

    security([%{bearer: []}])

    parameters do
      group(:body, Schema.ref(:NewGroup), "Data to create group", required: true)
    end

    response(201, "Success", Schema.ref(:Group))
    response(422, "Unprocessable entity (something wrong with body)")
    response(400, "Bad request (Unknown error)")
  end

  def create(conn, %{"group" => group_params}) do
    with {:ok, %Group{} = group} <- Groups.create_group(group_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/groups/#{group}")
      |> render(:show, group: group)
    end
  end

  swagger_path :show do
    get("/groups/{id}")
    summary("Query single group by id")
    description("Query single group by id.")
    produces("application/json")
    tag("Groups")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Group id", required: true)
    end

    response(200, "Success", Schema.ref(:Group))
    response(404, "Not found (group doesn't exists)")
    response(400, "Bad request (Unknown error)")
  end

  def show(conn, %{"id" => id}) do
    group = Groups.get_group!(id)
    render(conn, :show, group: group)
  end

  swagger_path :update do
    put("/groups/{id}")
    summary("Update existing group")
    description("Update existing group.")
    produces("application/json")
    tag("Groups")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Group id", required: true)
      group(:body, Schema.ref(:UpdateGroup), "Data to update group", required: true)
    end

    response(200, "Success", Schema.ref(:Group))
    response(404, "Not found (group doesn't exists)")
    response(422, "Unprocessable entity (something wrong with body)")
    response(400, "Bad request (Unknown error)")
  end

  def update(conn, %{"id" => id, "group" => group_params}) do
    group = Groups.get_group!(id)

    with {:ok, %Group{} = group} <- Groups.update_group(group, group_params) do
      render(conn, :show, group: group)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/groups/{id}")
    summary("Delete group by id")
    description("Delete group by id.")
    tag("Groups")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Group id", required: true)
    end

    response(204, "No content (group deleted)")
    response(404, "Not found (group doesn't exists)")
    response(400, "Bad request (Unknown error)")
  end

  def delete(conn, %{"id" => id}) do
    group = Groups.get_group!(id)

    with {:ok, %Group{}} <- Groups.delete_group(group) do
      send_resp(conn, :no_content, "")
    end
  end
end
