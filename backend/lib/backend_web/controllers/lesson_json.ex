defmodule BackendWeb.LessonJSON do
  alias Backend.Lessons.Lesson

  @doc """
  Renders a list of lessons.
  """
  def index(%{data: {:ok, %{list: list, pagination: pagination}}}) do
    %{list: for(lesson <- list, do: data(lesson)), pagination: pagination}
  end

  def index(%{data: {:error, _paylaod}}) do
    %{error: "Wrong params"}
  end

  @doc """
  Renders a single lesson.
  """
  def show(%{lesson: lesson}) do
    %{data: data(lesson)}
  end

  defp data(%Lesson{} = lesson) do
    %{
      id: lesson.id,
      title: lesson.title,
      description: lesson.description,
      topic: lesson.topic,
      is_draft: lesson.is_draft,
      inserted_at: lesson.inserted_at,
      updated_at: lesson.updated_at
    }
  end
end