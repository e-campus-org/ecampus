defmodule BackendWeb.GroupJSON do
  alias Backend.Groups.Group

  @doc """
  Renders a list of groups.
  """
  def index(%{groups: groups}) do
    %{data: for(group <- groups, do: data(group))}
  end

  @doc """
  Renders a single group.
  """
  def show(%{group: group}) do
    %{data: data(group)}
  end

  defp data(%Group{} = group) do
    %{
      id: group.id,
      title: group.title,
      description: group.description,
      speciality_id: group.speciality_id
    }
  end
end
