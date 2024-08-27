defmodule Backend.LessonTopics do
  @moduledoc """
  The LessonTopics context.
  """

  import Ecto.Query, warn: false
  import Backend.Pagination
  alias Backend.Repo

  alias Backend.LessonTopics.LessonTopic

  @doc """
  Returns the list of lesson_topics.

  ## Examples

      iex> list_lesson_topics()
      [%LessonTopic{}, ...]

  """

  def list_lesson_topics(params \\ %{}) do
    filters = []

    filters =
      params
      |> Enum.reduce(filters, fn
        {"lesson_id", lesson_id}, acc ->
          [%{field: :lesson_id, value: lesson_id} | acc]

        _, acc ->
          acc
      end)

    LessonTopic
    |> Flop.validate_and_run(
      %{
        page: Map.get(params, "page", 1),
        page_size: Map.get(params, "page_size", 10),
        filters: filters
      },
      for: LessonTopic
    )
    |> with_pagination()
  end

  @doc """
  Gets a single lesson_topic.

  Raises `Ecto.NoResultsError` if the Lesson topic does not exist.

  ## Examples

      iex> get_lesson_topic!(123)
      %LessonTopic{}

      iex> get_lesson_topic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_lesson_topic!(id), do: Repo.get!(LessonTopic, id)

  @doc """
  Creates a lesson_topic.

  ## Examples

      iex> create_lesson_topic(%{field: value})
      {:ok, %LessonTopic{}}

      iex> create_lesson_topic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_lesson_topic(attrs \\ %{}) do
    %LessonTopic{}
    |> LessonTopic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a lesson_topic.

  ## Examples

      iex> update_lesson_topic(lesson_topic, %{field: new_value})
      {:ok, %LessonTopic{}}

      iex> update_lesson_topic(lesson_topic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_lesson_topic(%LessonTopic{} = lesson_topic, attrs) do
    lesson_topic
    |> LessonTopic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a lesson_topic.

  ## Examples

      iex> delete_lesson_topic(lesson_topic)
      {:ok, %LessonTopic{}}

      iex> delete_lesson_topic(lesson_topic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_lesson_topic(%LessonTopic{} = lesson_topic) do
    Repo.delete(lesson_topic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking lesson_topic changes.

  ## Examples

      iex> change_lesson_topic(lesson_topic)
      %Ecto.Changeset{data: %LessonTopic{}}

  """
  def change_lesson_topic(%LessonTopic{} = lesson_topic, attrs \\ %{}) do
    LessonTopic.changeset(lesson_topic, attrs)
  end
end
