defmodule Backend.Quizzes do
  @moduledoc """
  The Quizzes context.
  """

  import Ecto.Query, warn: false
  import Backend.Pagination
  alias Backend.Repo

  alias Backend.Quizzes.Quiz

  alias Backend.Questions.Question

  @doc """
  Returns the list of quizzes.

  ## Examples

      iex> list_quizzes()
      [%Quiz{}, ...]

  """
  def list_quizzes(params \\ %{}) do
    filters = []

    filters =
      params
      |> Enum.reduce(filters, fn
        {"lesson_id", lesson_id}, acc ->
          [%{field: :lesson_id, value: lesson_id} | acc]

        _, acc ->
          acc
      end)

    Quiz
    |> preload([:questions])
    |> Flop.validate_and_run(
      %{
        page: Map.get(params, "page", 1),
        page_size: Map.get(params, "page_size", 10),
        filters: filters
      },
      for: Quiz
    )
    |> with_pagination()
  end

  @doc """
  Gets a single quiz.

  Raises `Ecto.NoResultsError` if the Quiz does not exist.

  ## Examples

      iex> get_quiz!(123)
      %Quiz{}

      iex> get_quiz!(456)
      ** (Ecto.NoResultsError)

  """
  def get_quiz!(id),
    do: Repo.get!(Quiz, id) |> Repo.preload([:questions])

  @doc """
  Creates a quiz.

  ## Examples

      iex> create_quiz(%{field: value})
      {:ok, %Quiz{}}

      iex> create_quiz(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_quiz(attrs \\ %{}) do
    changeset =
      %Quiz{}
      |> Quiz.changeset(attrs)

    with {:ok, quiz} <- Repo.insert(changeset) do
      {:ok, Repo.preload(quiz, [:questions])}
    end
  end

  @doc """
  Updates a quiz.

  ## Examples

      iex> update_quiz(quiz, %{field: new_value})
      {:ok, %Quiz{}}

      iex> update_quiz(quiz, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_quiz(%Quiz{} = quiz, attrs) do
    changeset =
      quiz
      |> Quiz.changeset(attrs)

    with {:ok, quiz} <- Repo.update(changeset) do
      {:ok, Repo.preload(quiz, [:questions])}
    end
  end

  @doc """
  Deletes a quiz.

  ## Examples

      iex> delete_quiz(quiz)
      {:ok, %Quiz{}}

      iex> delete_quiz(quiz)
      {:error, %Ecto.Changeset{}}

  """
  def delete_quiz(%Quiz{} = quiz) do
    Repo.delete(quiz)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking quiz changes.

  ## Examples

      iex> change_quiz(quiz)
      %Ecto.Changeset{data: %Quiz{}}

  """
  def change_quiz(%Quiz{} = quiz, attrs \\ %{}) do
    Quiz.changeset(quiz, attrs)
  end

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question(attrs \\ %{}) do
    changeset =
      %Question{}
      |> Question.changeset(attrs)

    with {:ok, question} <- Repo.insert(changeset) do
      get_quiz!(question.quiz_id)
    end
  end

  @doc """
  Updates a question.

  ## Examples

      iex> update_question(question, %{field: new_value})
      {:ok, %Question{}}

      iex> update_question(question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question(%Question{} = question, attrs) do
    changeset =
      question
      |> Question.changeset(attrs)

    with {:ok, question} <- Repo.update(changeset) do
      get_quiz!(question.quiz_id)
    end
  end

  @doc """
  Deletes a question.

  ## Examples

      iex> delete_question(question)
      {:ok, %Question{}}

      iex> delete_question(question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question(id) do
    with question <- Repo.get!(Question, id) do
      Repo.delete(question)
      get_quiz!(question.quiz_id)
    end
  end
end
