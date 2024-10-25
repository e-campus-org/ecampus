defmodule BackendWeb.QuizController do
  use BackendWeb, :controller

  alias Backend.Quizzes
  alias Backend.Quizzes.Quiz

  alias Backend.Questions
  alias Backend.QuizzesQuestions.QuizQuestion

  import Backend.Auth.Plugs

  action_fallback(BackendWeb.FallbackController)

  plug(:is_teacher when action not in [:answer_question])
  plug(:is_student when action in [:answer_question])

  def index(conn, params) do
    data = Quizzes.list_quizzes(params)
    render(conn, :index, data: data)
  end

  def create(conn, %{"quiz" => quiz_params}) do
    with {:ok, %Quiz{} = quiz} <- Quizzes.create_quiz(quiz_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/quizzes/#{quiz}")
      |> render(:show, quiz: quiz)
    end
  end

  def show(conn, %{"id" => id}) do
    quiz = Quizzes.get_quiz!(id)
    render(conn, :show, quiz: quiz)
  end

  def update(conn, %{"id" => id, "quiz" => quiz_params}) do
    quiz = Quizzes.get_quiz!(id)

    with {:ok, %Quiz{} = quiz} <- Quizzes.update_quiz(quiz, quiz_params) do
      render(conn, :show, quiz: quiz)
    end
  end

  def delete(conn, %{"id" => id}) do
    quiz = Quizzes.get_quiz!(id)

    with {:ok, %Quiz{}} <- Quizzes.delete_quiz(quiz) do
      send_resp(conn, :no_content, "")
    end
  end

  def create_question(conn, %{"id" => id, "question" => question_params}) do
    with question <-
           question_params
           |> Map.put("quiz_id", String.to_integer(id))
           |> Quizzes.create_question() do
      conn
      |> put_status(:created)
      |> render(:show_question, question: question)
    end
  end

  def update_question(conn, %{
        "id" => id,
        "question_id" => question_id,
        "question" => question_params
      }) do
    id |> IO.inspect()
    question_params = Map.put(question_params, "quiz_id", String.to_integer(id))

    quiz =
      Questions.get_question!(question_id)
      |> Quizzes.update_question(question_params)

    render(conn, :show, quiz: quiz)
  end

  def delete_question(conn, %{"id" => id, "question_id" => question_id}) do
    with {:ok, %QuizQuestion{}} <-
           Quizzes.delete_question(%QuizQuestion{
             quiz_id: String.to_integer(id),
             question_id: String.to_integer(question_id)
           }) do
      send_resp(conn, :no_content, "")
    end
  end

  def answer_question(conn, %{"id" => id, "question_id" => question_id, "answer" => answer}) do
    %{private: %{:guardian_default_resource => %{"account" => %{"id" => account_id}}}} = conn

    question =
      Quizzes.answer_question(%{
        quiz_id: String.to_integer(id),
        question_id: String.to_integer(question_id),
        student_id: account_id,
        answer: answer
      })

    render(conn, :show_student_question, question: question)
  end
end
