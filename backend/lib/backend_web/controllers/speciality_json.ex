defmodule BackendWeb.SpecialityJSON do
  alias Backend.Specialities.Speciality

  @doc """
  Renders a list of specialities.
  """

  def index(%{data: {:ok, %{list: list, pagination: pagination}}}) do
    %{list: for(speciality <- list, do: data(speciality)), pagination: pagination}
  end

  def index(%{data: {:error, _paylaod}}) do
    %{error: "Wrong params"}
  end

  @doc """
  Renders a single speciality.
  """
  def show(%{speciality: speciality}) do
    %{data: data(speciality)}
  end

  defp data(%Speciality{} = speciality) do
    %{
      id: speciality.id,
      code: speciality.code,
      title: speciality.title,
      description: speciality.description,
      inserted_at: speciality.inserted_at,
      updated_at: speciality.updated_at
    }
  end
end
