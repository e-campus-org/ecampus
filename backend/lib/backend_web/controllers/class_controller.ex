defmodule BackendWeb.ClassController do
  use BackendWeb, :controller

  alias Backend.Classes
  alias Backend.Classes.Class

  import Backend.Auth.Plugs

  action_fallback(BackendWeb.FallbackController)

  plug(:is_teacher when action in [:create, :update, :delete])

  def index(conn, params) do
    data = Classes.list_classes(params)
    render(conn, :index, data: data)
  end

  def create(conn, %{"class" => class_params}) do
    with {:ok, %Class{} = class} <- Classes.create_class(class_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/classes/#{class}")
      |> render(:show, class: class)
    end
  end

  def show(conn, %{"id" => id}) do
    class = Classes.get_class!(id)
    render(conn, :show, class: class)
  end

  def update(conn, %{"id" => id, "class" => class_params}) do
    class = Classes.get_class!(id)

    with {:ok, %Class{} = class} <- Classes.update_class(class, class_params) do
      render(conn, :show, class: class)
    end
  end

  def delete(conn, %{"id" => id}) do
    class = Classes.get_class!(id)

    with {:ok, %Class{}} <- Classes.delete_class(class) do
      send_resp(conn, :no_content, "")
    end
  end

  def link_class_with_teacher(
        conn,
        %{
          "class_id" => _subject_id,
          "taught_by_id" => _account_id
        } = params
      ) do
    with {:ok, class} <-
           Classes.link_class_with_teacher(params) do
      render(conn, :show, class: class)
    end
  end
end
