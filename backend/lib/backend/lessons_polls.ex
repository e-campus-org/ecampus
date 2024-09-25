defmodule Backend.LessonsPolls do
  @moduledoc """
  The LessonsPolls context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.LessonsPolls.LessonPoll

  @doc """
  Returns the list of lessons_polls.

  ## Examples

      iex> list_lessons_polls()
      [%LessonPoll{}, ...]

  """
  def list_lessons_polls do
    Repo.all(LessonPoll)
  end

  @doc """
  Gets a single lesson_poll.

  Raises `Ecto.NoResultsError` if the Lesson poll does not exist.

  ## Examples

      iex> get_lesson_poll!(123)
      %LessonPoll{}

      iex> get_lesson_poll!(456)
      ** (Ecto.NoResultsError)

  """
  def get_lesson_poll!(id), do: Repo.get!(LessonPoll, id)

  @doc """
  Creates a lesson_poll.

  ## Examples

      iex> create_lesson_poll(%{field: value})
      {:ok, %LessonPoll{}}

      iex> create_lesson_poll(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_lesson_poll(attrs \\ %{}) do
    %LessonPoll{}
    |> LessonPoll.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a lesson_poll.

  ## Examples

      iex> update_lesson_poll(lesson_poll, %{field: new_value})
      {:ok, %LessonPoll{}}

      iex> update_lesson_poll(lesson_poll, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_lesson_poll(%LessonPoll{} = lesson_poll, attrs) do
    lesson_poll
    |> LessonPoll.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a lesson_poll.

  ## Examples

      iex> delete_lesson_poll(lesson_poll)
      {:ok, %LessonPoll{}}

      iex> delete_lesson_poll(lesson_poll)
      {:error, %Ecto.Changeset{}}

  """
  def delete_lesson_poll(%LessonPoll{} = lesson_poll) do
    Repo.delete(lesson_poll)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking lesson_poll changes.

  ## Examples

      iex> change_lesson_poll(lesson_poll)
      %Ecto.Changeset{data: %LessonPoll{}}

  """
  def change_lesson_poll(%LessonPoll{} = lesson_poll, attrs \\ %{}) do
    LessonPoll.changeset(lesson_poll, attrs)
  end
end
