defmodule BackendWeb.QuizJSON do
  alias Backend.Quizzes.Quiz
  alias Backend.Questions.Question
  alias Backend.Questions.Question.Answer

  @doc """
  Renders a list of quizzes.
  """
  def index(%{data: {:ok, %{list: list, pagination: pagination}}}) do
    %{list: for(class <- list, do: data(class)), pagination: pagination}
  end

  @doc """
  Renders a single quiz.
  """
  def show(%{quiz: quiz}), do: data(quiz)

  defp data(%Quiz{} = quiz) do
    %{
      id: quiz.id,
      title: quiz.title,
      description: quiz.description,
      estimation: quiz.estimation,
      lesson_id: quiz.lesson_id,
      questions: for(question <- quiz.questions, do: data_question(question)),
      inserted_at: quiz.inserted_at,
      updated_at: quiz.updated_at
    }
  end

  defp data_question(%Question{} = question) do
    %{
      id: question.id,
      type: question.type,
      title: question.title,
      subtitle: question.subtitle,
      grade: question.grade,
      quiz_id: question.quiz_id,
      answers: for(answer <- question.answers, do: data_answer(answer)),
      inserted_at: question.inserted_at,
      updated_at: question.updated_at
    }
  end

  defp data_answer(%Answer{} = answer) do
    %{
      id: answer.id,
      title: answer.title,
      subtitle: answer.subtitle,
      is_correct: answer.is_correct,
      correct_value: answer.correct_value,
      sequence_order_number: answer.sequence_order_number
    }
  end
end
