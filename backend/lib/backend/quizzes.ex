defmodule Backend.Quizzes do
  @moduledoc """
  The Quizzes context.
  """

  import Ecto.Query, warn: false
  import Backend.Pagination

  alias Backend.Repo

  alias Backend.Quizzes.Quiz

  alias Backend.Quizzes.Question

  alias Backend.Quizzes.QuizQuestion

  alias Backend.Quizzes.AnsweredQuestion

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
    |> preload([:questions, questions: [:answers]])
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
    do: Repo.get!(Quiz, id) |> Repo.preload([:questions, questions: [:answers]])

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
      {:ok, Repo.preload(quiz, [:questions, questions: [:answers]])}
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
      {:ok, Repo.preload(quiz, [:questions, questions: [:answers]])}
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
  Gets a single question.

  Raises `Ecto.NoResultsError` if the Question does not exist.

  ## Examples

      iex> get_question!(123)
      %Question{}

      iex> get_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_question!(id), do: Repo.get!(Question, id) |> Repo.preload([:answers])

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question(attrs \\ %{}) do
    with {:ok, %{questions: question}} <-
           Ecto.Multi.new()
           |> Ecto.Multi.insert(:questions, Question.changeset(%Question{}, attrs))
           |> Ecto.Multi.insert(
             :quizzes_questions,
             fn %{questions: %Question{id: question_id}} ->
               QuizQuestion.changeset(%QuizQuestion{}, %{
                 question_id: question_id,
                 quiz_id: Map.get(attrs, "quiz_id")
               })
             end
           )
           |> Repo.transaction() do
      question |> Repo.preload([:answers])
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
      {:ok, %QuizQuestion{}}

      iex> delete_question(question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question(%{quiz_id: quiz_id, question_id: question_id}) do
    Repo.get_by!(QuizQuestion, quiz_id: quiz_id, question_id: question_id)
    |> Repo.delete()
  end

  def get_started_quiz(%{
        quiz_id: quiz_id,
        student_id: student_id
      }) do
    Repo.get!(Backend.Quizzes.Quiz, quiz_id)
    |> Repo.preload(
      questions:
        from(q in Backend.Quizzes.Question,
          join: aq in assoc(q, :answered_questions),
          where: aq.student_id == ^student_id
        )
    )
    |> Repo.preload(questions: [:answers, :answered_questions])
  end

  def start_quiz(%{
        quiz_id: quiz_id,
        student_id: student_id
      }),
      do:
        Repo.get!(Quiz, quiz_id)
        |> Repo.preload([:questions, questions: [:answers]])
        |> shuffle_and_get_question()
        |> create_empty_answered_questions(student_id)
        |> insert_empty_answered_questions()

  defp insert_empty_answered_questions(quiz) do
    Repo.transaction(fn ->
      Enum.each(quiz.questions, &Repo.insert(&1, []))
    end)
  end

  defp create_empty_answered_questions(%Quiz{} = quiz, student_id),
    do: %{
      quiz
      | questions:
          Enum.map(quiz.questions, fn question ->
            %AnsweredQuestion{}
            |> AnsweredQuestion.changeset(%{
              quiz_id: quiz.id,
              question_id: question.id,
              student_id: student_id,
              answer: nil
            })
          end)
    }

  defp shuffle_and_get_question(%Quiz{} = quiz),
    do: %{
      quiz
      | questions:
          Enum.shuffle(quiz.questions)
          |> Enum.take(quiz.questions_per_attempt)
    }

  def answer_question(%{
        question_id: question_id,
        student_id: student_id,
        answer: answer
      }) do
    with processed_answer when not is_nil(processed_answer) <-
           from(q in Backend.Quizzes.Question,
             join: aq in assoc(q, :answered_questions),
             where: aq.student_id == ^student_id and is_nil(aq.answer)
           )
           |> Repo.one()
           |> Repo.preload([:answers])
           |> apply_answer(answer) do
      Repo.update_all(
        from(aq in AnsweredQuestion,
          where: aq.student_id == ^student_id and aq.question_id == ^question_id
        ),
        set: [answer: processed_answer, updated_at: DateTime.utc_now()]
      )

      {:ok, Repo.get!(Question, question_id) |> Repo.preload([:answers, :answered_questions])}
    else
      nil ->
        {:error, "Already answered"}
    end
  end

  defp apply_answer(%{type: :single} = question, %{"answer_id" => answer_id} = answer) do
    case Enum.find(question.answers, & &1.is_correct) do
      %{id: ^answer_id} ->
        Map.merge(answer, %{grade: question.grade, correct: answer_id})

      %{id: correct_id} ->
        Map.merge(answer, %{grade: 0, correct: correct_id})
    end
  end

  defp apply_answer(%{type: :multiple} = question, %{"answer_ids" => answer_ids} = answer) do
    correct_ids =
      question.answers
      |> Enum.filter(& &1.is_correct)
      |> Enum.map(& &1.id)
      |> Enum.sort()

    answer_ids = answer_ids |> Enum.sort()

    cond do
      answer_ids == correct_ids ->
        Map.merge(answer, %{grade: question.grade, correct: answer_ids})

      true ->
        points_per_answer = question.grade / length(correct_ids)

        correct_count =
          answer_ids
          |> Enum.filter(&Enum.member?(correct_ids, &1))
          |> length()

        incorrect_count = length(answer_ids) - correct_count

        Map.merge(answer, %{
          grade: max(0, points_per_answer * (correct_count - incorrect_count)),
          correct: correct_ids
        })
    end
  end

  defp apply_answer(nil, _), do: nil

  defp apply_answer(_question, answer) do
    Map.merge(answer, %{grade: 0})
  end
end
