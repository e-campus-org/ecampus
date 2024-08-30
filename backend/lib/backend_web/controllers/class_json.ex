defmodule BackendWeb.ClassJSON do
  alias Backend.Classes.Class
  alias Backend.LessonTopics.LessonTopic

  @doc """
  Renders a list of classes.
  """
  def index(%{data: {:ok, %{list: list, pagination: pagination}}}) do
    %{list: for(class <- list, do: short_data(class)), pagination: pagination}
  end

  def index(%{data: {:error, _paylaod}}) do
    %{error: "Wrong params"}
  end

  @doc """
  Renders a single class.
  """
  def show(%{class: class}), do: data(class)

  defp short_data(%Class{} = class) do
    %{
      id: class.id,
      begin_date: class.begin_date,
      classroom: class.classroom,
      lesson: %{
        id: class.lesson_id,
        title: class.lesson.title,
        topic: class.lesson.topic,
        hours_count: class.lesson.hours_count,
        subject_id: class.lesson.subject_id
      },
      group: %{
        id: class.group_id,
        title: class.group.title
      },
      inserted_at: class.inserted_at,
      updated_at: class.updated_at
    }
  end

  defp data(%Class{} = class) do
    %{
      id: class.id,
      begin_date: class.begin_date,
      classroom: class.classroom,
      lesson: %{
        id: class.lesson_id,
        title: class.lesson.title,
        topic: class.lesson.topic,
        hours_count: class.lesson.hours_count,
        subject_id: class.lesson.subject_id,
        topics: for(topic <- class.lesson.topics, do: data_topic(topic))
      },
      group: %{
        id: class.group_id,
        title: class.group.title
      },
      inserted_at: class.inserted_at,
      updated_at: class.updated_at
    }
  end

  defp data_topic(%LessonTopic{} = lesson_topic) do
    %{
      id: lesson_topic.id,
      title: lesson_topic.title,
      content: lesson_topic.content,
      inserted_at: lesson_topic.inserted_at,
      updated_at: lesson_topic.updated_at,
      lesson_id: lesson_topic.lesson_id
    }
  end
end
