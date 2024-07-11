defmodule BackendWeb.SpecialityController do
  use BackendWeb, :controller

  alias Backend.Specialities
  alias Backend.Specialities.Speciality

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    specialities = Specialities.list_specialities()
    render(conn, :index, specialities: specialities)
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

    with {:ok, %Speciality{} = speciality} <- Specialities.update_speciality(speciality, speciality_params) do
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
