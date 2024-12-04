defmodule BackendWeb.GroupController do
  use BackendWeb, :controller

  alias Backend.Groups
  alias Backend.Groups.Group

  import Backend.Auth.Plugs

  action_fallback(BackendWeb.FallbackController)

  plug(:admin? when action in [:create, :update, :delete])

  def index(conn, %{"page" => _page, "page_size" => _page_size} = params) do
    data = Groups.list_groups(params)
    render(conn, :index, data: data)
  end

  def index(conn, _params) do
    data = Groups.list_groups(%{"page" => 1, "page_size" => 10})
    render(conn, :index, data: data)
  end

  def create(conn, %{"group" => group_params}) do
    with {:ok, %Group{} = group} <- Groups.create_group(group_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/groups/#{group}")
      |> render(:show, group: group)
    end
  end

  def show(conn, %{"id" => id}) do
    group = Groups.get_group!(id)
    render(conn, :show, group: group)
  end

  def show_subjects(conn, %{"id" => group_id}) do
    subjects = Groups.get_group_subjects(group_id)
    render(conn, :index_subjects, subjects: subjects)
  end

  def update(conn, %{"id" => id, "group" => group_params}) do
    group = Groups.get_group!(id)

    with {:ok, %Group{} = group} <- Groups.update_group(group, group_params) do
      render(conn, :show, group: group)
    end
  end

  def delete(conn, %{"id" => id}) do
    group = Groups.get_group!(id)

    with {:ok, %Group{}} <- Groups.delete_group(group) do
      send_resp(conn, :no_content, "")
    end
  end
end
