defmodule BackendWeb.LessonTopicJSON do
  alias Backend.LessonTopics.LessonTopic

  @doc """
  Renders a list of lesson_topics.
  """

  def index(%{data: {:ok, %{list: list, pagination: pagination}}}) do
    %{list: for(lesson_topic <- list, do: data(lesson_topic)), pagination: pagination}
  end

  def index(%{data: {:error, _paylaod}}) do
    %{error: "Wrong params"}
  end

  @doc """
  Renders a single lesson_topic.
  """
  def show(%{lesson_topic: lesson_topic}) do
    %{data: data(lesson_topic)}
  end

  defp data(%LessonTopic{} = lesson_topic) do
    %{
      id: lesson_topic.id,
      title: lesson_topic.title,
      content: lesson_topic.content,
      description: lesson_topic.description,
      objectives: lesson_topic.objectives,
      inserted_at: lesson_topic.inserted_at,
      updated_at: lesson_topic.updated_at
    }
  end
end
