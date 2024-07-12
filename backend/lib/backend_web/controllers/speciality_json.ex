defmodule BackendWeb.SpecialityJSON do
  alias Backend.Specialities.Speciality

  @doc """
  Renders a list of specialities.
  """
  def index(%{specialities: specialities}) do
    %{data: for(speciality <- specialities, do: data(speciality))}
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
      description: speciality.description
    }
  end
end
