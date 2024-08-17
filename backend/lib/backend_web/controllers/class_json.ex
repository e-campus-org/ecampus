defmodule BackendWeb.ClassJSON do
  alias Backend.Classes.Class

  @doc """
  Renders a list of classes.
  """
  def index(%{data: {:ok, %{list: list, pagination: pagination}}}) do
    %{list: for(class <- list, do: data(class)), pagination: pagination}
  end

  def index(%{data: {:error, _paylaod}}) do
    %{error: "Wrong params"}
  end

  @doc """
  Renders a single class.
  """
  def show(%{class: class}) do
    %{data: data(class)}
  end

  defp data(%Class{} = class) do
    %{
      id: class.id,
      begin_date: class.begin_date,
      classroom: class.classroom,
      lesson: %{
        id: class.lesson_id,
        title: class.lesson.title,
        topic: class.lesson.topic
      },
      group: %{
        id: class.group_id,
        title: class.group.title
      },
      inserted_at: class.inserted_at,
      updated_at: class.updated_at
    }
  end
end
