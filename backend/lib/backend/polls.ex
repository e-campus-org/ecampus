defmodule Backend.Polls do
  @moduledoc """
  The Polls context.
  """

  import Ecto.Query, warn: false
  import Backend.Pagination
  alias Backend.Repo

  alias Backend.Polls.Poll

  @doc """
  Returns the list of polls.

  ## Examples

      iex> list_polls()
      [%Poll{}, ...]

  """
  def list_polls(params \\ %{}) do
    filters = []

    Poll
    |> preload([:poll_questions, poll_questions: [:poll_answers]])
    |> Flop.validate_and_run(
      %{
        page: Map.get(params, "page", 1),
        page_size: Map.get(params, "page_size", 10),
        filters: filters
      },
      for: Poll
    )
    |> with_pagination()
  end

  @doc """
  Gets a single poll.

  Raises `Ecto.NoResultsError` if the Poll does not exist.

  ## Examples

      iex> get_poll!(123)
      %Poll{}

      iex> get_poll!(456)
      ** (Ecto.NoResultsError)

  """
  def get_poll!(id),
    do: Repo.get!(Poll, id) |> Repo.preload([:poll_questions, poll_questions: [:poll_answers]])

  @doc """
  Creates a poll.

  ## Examples

      iex> create_poll(%{field: value})
      {:ok, %Poll{}}

      iex> create_poll(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_poll(attrs \\ %{}) do
    changeset =
      %Poll{}
      |> Poll.changeset(attrs)

    with {:ok, poll} <- Repo.insert(changeset) do
      {:ok, Repo.preload(poll, [:poll_questions, poll_questions: [:poll_answers]])}
    end
  end

  @doc """
  Updates a poll.

  ## Examples

      iex> update_poll(poll, %{field: new_value})
      {:ok, %Poll{}}

      iex> update_poll(poll, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_poll(%Poll{} = poll, attrs) do
    changeset =
      poll
      |> Poll.changeset(attrs)

    with {:ok, poll} <- Repo.update(changeset) do
      {:ok, Repo.preload(poll, [:poll_questions, poll_questions: [:poll_answers]])}
    end
  end

  @doc """
  Deletes a poll.

  ## Examples

      iex> delete_poll(poll)
      {:ok, %Poll{}}

      iex> delete_poll(poll)
      {:error, %Ecto.Changeset{}}

  """
  def delete_poll(%Poll{} = poll) do
    Repo.delete(poll)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking poll changes.

  ## Examples

      iex> change_poll(poll)
      %Ecto.Changeset{data: %Poll{}}

  """
  def change_poll(%Poll{} = poll, attrs \\ %{}) do
    Poll.changeset(poll, attrs)
  end

  alias Backend.Polls.PollQuestion

  @doc """
  Returns the list of polls.

  ## Examples

      iex> list_poll_questions()
      [%PollQuestion{}, ...]

  """
  def list_poll_questions do
    Repo.all(PollQuestion)
  end

  @doc """
  Gets a single poll_question.

  Raises `Ecto.NoResultsError` if the Poll question does not exist.

  ## Examples

      iex> get_poll_question!(123)
      %PollQuestion{}

      iex> get_poll_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_poll_question!(id), do: Repo.get!(PollQuestion, id) |> Repo.preload([:poll_answers])

  @doc """
  Creates a poll_question.

  ## Examples

      iex> create_poll_question(%{field: value})
      {:ok, %PollQuestion{}}

      iex> create_poll_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_poll_question(attrs \\ %{}) do
    changeset =
      %PollQuestion{}
      |> PollQuestion.changeset(attrs)

    with {:ok, poll_question} <- Repo.insert(changeset) do
      {:ok, Repo.preload(poll_question, [:poll_answers])}
    end
  end

  @doc """
  Updates a poll_question.

  ## Examples

      iex> update_poll_question(poll_question, %{field: new_value})
      {:ok, %PollQuestion{}}

      iex> update_poll_question(poll_question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_poll_question(%PollQuestion{} = poll_question, attrs) do
    changeset =
      poll_question
      |> PollQuestion.changeset(attrs)

    with {:ok, poll_question} <- Repo.update(changeset) do
      {:ok, Repo.preload(poll_question, [:poll_answers])}
    end
  end

  @doc """
  Deletes a poll_question.

  ## Examples

      iex> delete_poll_question(poll_question)
      {:ok, %PollQuestion{}}

      iex> delete_poll_question(poll_question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_poll_question(%PollQuestion{} = poll_question) do
    Repo.delete(poll_question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking poll_question changes.

  ## Examples

      iex> change_poll_question(poll_question)
      %Ecto.Changeset{data: %PollQuestion{}}

  """
  def change_poll_question(%PollQuestion{} = poll_question, attrs \\ %{}) do
    PollQuestion.changeset(poll_question, attrs)
  end

  alias Backend.Polls.PollAnswer

  @doc """
  Returns the list of poll_answers.

  ## Examples

      iex> list_poll_answers()
      [%PollAnswer{}, ...]

  """
  def list_poll_answers do
    Repo.all(PollAnswer)
  end

  @doc """
  Gets a single poll_answer.

  Raises `Ecto.NoResultsError` if the Poll answer does not exist.

  ## Examples

      iex> get_poll_answer!(123)
      %PollAnswer{}

      iex> get_poll_answer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_poll_answer!(id), do: Repo.get!(PollAnswer, id)

  @doc """
  Creates a poll_answer.

  ## Examples

      iex> create_poll_answer(%{field: value})
      {:ok, %PollAnswer{}}

      iex> create_poll_answer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_poll_answer(attrs \\ %{}) do
    %PollAnswer{}
    |> PollAnswer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a poll_answer.

  ## Examples

      iex> update_poll_answer(poll_answer, %{field: new_value})
      {:ok, %PollAnswer{}}

      iex> update_poll_answer(poll_answer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_poll_answer(%PollAnswer{} = poll_answer, attrs) do
    poll_answer
    |> PollAnswer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a poll_answer.

  ## Examples

      iex> delete_poll_answer(poll_answer)
      {:ok, %PollAnswer{}}

      iex> delete_poll_answer(poll_answer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_poll_answer(%PollAnswer{} = poll_answer) do
    Repo.delete(poll_answer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking poll_answer changes.

  ## Examples

      iex> change_poll_answer(poll_answer)
      %Ecto.Changeset{data: %PollAnswer{}}

  """
  def change_poll_answer(%PollAnswer{} = poll_answer, attrs \\ %{}) do
    PollAnswer.changeset(poll_answer, attrs)
  end
end
