defmodule BackendWeb.GroupJSON do
  alias Backend.Groups.Group
  alias Backend.Subjects.Subject

  @doc """
  Renders a list of groups.
  """
  def index(%{data: {:ok, %{list: list, pagination: pagination}}}) do
    %{list: for(group <- list, do: data(group)), pagination: pagination}
  end

  def index(%{data: {:error, _paylaod}}) do
    %{error: "Wrong params"}
  end

  def index_subjects(%{subjects: subjects}) do
    for(subject <- subjects, do: data_subject(subject))
  end

  @doc """
  Renders a single group.
  """
  def show(%{group: group}), do: data(group)

  defp data(%Group{} = group) do
    %{
      id: group.id,
      title: group.title,
      description: group.description,
      speciality_id: group.speciality_id,
      created_at: group.inserted_at,
      updated_at: group.updated_at
    }
  end

  # def show_subject()
  defp data_subject(%Subject{} = subject) do
    %{
      id: subject.id,
      title: subject.title,
      short_title: subject.short_title,
      description: subject.description
    }
  end
end
