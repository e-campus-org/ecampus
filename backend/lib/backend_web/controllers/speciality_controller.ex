defmodule BackendWeb.SpecialityController do
  use BackendWeb, :controller

  alias Backend.Specialities
  alias Backend.Specialities.Speciality

  import Backend.Auth.Plugs

  action_fallback(BackendWeb.FallbackController)

  plug(:is_admin when action in [:create, :update, :delete])

  def index(conn, %{"page" => _page, "page_size" => _page_size} = params) do
    data = Specialities.list_specialities(params)
    render(conn, :index, data: data)
  end

  def index(conn, _params) do
    data = Specialities.list_specialities(%{"page" => 1, "page_size" => 10})
    render(conn, :index, data: data)
  end

  def create(conn, %{"speciality" => speciality_params}) do
    with {:ok, %Speciality{} = speciality} <- Specialities.create_speciality(speciality_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/specialities/#{speciality}")
      |> render(:show, speciality: speciality)
    end
  end

  def show(conn, %{"id" => id}) do
    speciality = Specialities.get_speciality!(id)
    render(conn, :show, speciality: speciality)
  end

  def update(conn, %{"id" => id, "speciality" => speciality_params}) do
    speciality = Specialities.get_speciality!(id)

    with {:ok, %Speciality{} = speciality} <-
           Specialities.update_speciality(speciality, speciality_params) do
      render(conn, :show, speciality: speciality)
    end
  end

  def delete(conn, %{"id" => id}) do
    speciality = Specialities.get_speciality!(id)

    with {:ok, %Speciality{}} <- Specialities.delete_speciality(speciality) do
      send_resp(conn, :no_content, "")
    end
  end
end
