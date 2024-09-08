defmodule BackendWeb.QuizController do
  use BackendWeb, :controller

  use PhoenixSwagger

  alias Backend.Quizzes
  alias Backend.Quizzes.Quiz

  alias Backend.Questions
  alias Backend.QuizzesQuestions.QuizQuestion

  import Backend.Auth.Plugs

  action_fallback(BackendWeb.FallbackController)

  plug(:is_teacher when action not in [:answer_question])
  plug(:is_student when action in [:answer_question])

  def swagger_definitions do
    %{
      Answer:
        swagger_schema do
          title("Answer")
          description("A quiz question answer object")

          properties do
            id(:number, "Unique identifier")
            title(:string, "Answer title")
            subtitle(:string, "Answer subtitle")
            is_correct(:boolean, "Is current answer correct")
            correct_value(:string, "Correct answer value")

            sequence_order_number(
              :number,
              "Order number of answer when question type is 'sequence'"
            )
          end

          example(%{
            id: 1,
            title: "Lorem ipsum dolor sit amet",
            subtitle: "Lorem ipsum dolor sit amet",
            is_correct: true,
            correct_value: "Lorem ipsum dolor sit amet",
            sequence_order_number: 1
          })
        end,
      Answers:
        swagger_schema do
          title("List of question answers")
          description("A collection of Answer")
          type(:array)
          items(Schema.ref(:Answer))
        end,
      Question:
        swagger_schema do
          title("Question")
          description("A quiz question object")

          properties do
            id(:number, "Unique identifier")
            title(:string, "Question title")
            subtitle(:string, "Question subtitle")
            grade(:number, "Question grade")

            type(:enum, "Question type",
              enum: [:single, :multiple, :sequence],
              default: [:single]
            )

            quiz_id(:number, "Question quiz id belongs to")
            answers(Schema.ref(:Answers), "List of quiz question answers")
            inserted_at(:datetime, "Date and time of quiz question creation")
            updated_at(:datetime, "Date and time of quiz question last update")
          end

          example(%{
            id: 1,
            title: "Lorem ipsum dolor sit amet",
            subtitle: "Lorem ipsum dolor sit amet",
            grade: 5,
            type: "single",
            quiz_id: 1,
            answers: [
              %{
                id: 1,
                title: "Lorem ipsum dolor sit amet",
                subtitle: "Lorem ipsum dolor sit amet",
                is_correct: true,
                correct_value: "Lorem ipsum dolor sit amet",
                sequence_order_number: 1
              }
            ],
            inserted_at: "2024-07-11T05:47:50Z",
            updated_at: "2024-07-11T05:47:50Z"
          })
        end,
      NewQuestion:
        swagger_schema do
          title("New question")
          description("Data object to create new question")

          properties do
            title(:string, "Question title", required: true)
            subtitle(:string, "Question subtitle")
            grade(:number, "Question grade", required: true)

            type(:enum, "Question type",
              enum: [:single, :multiple, :sequence],
              default: [:single]
            )

            answers(Schema.ref(:Answers), "List of quiz question answers")
          end

          example(%{
            title: "Lorem ipsum dolor sit amet",
            subtitle: "Lorem ipsum dolor sit amet",
            grade: 5,
            type: "single",
            quiz_id: 1,
            answers: [
              %{
                id: 1,
                title: "Lorem ipsum dolor sit amet",
                subtitle: "Lorem ipsum dolor sit amet",
                is_correct: true,
                correct_value: "Lorem ipsum dolor sit amet",
                sequence_order_number: 1
              }
            ]
          })
        end,
      UpdateQuestion:
        swagger_schema do
          title("Update existing question")
          description("Data object to update question")

          properties do
            title(:string, "Question title")
            subtitle(:string, "Question subtitle")
            grade(:number, "Question grade")

            type(:enum, "Question type",
              enum: [:single, :multiple, :sequence],
              default: [:single]
            )

            answers(Schema.ref(:Answers), "List of quiz question answers")
          end

          example(%{
            title: "Lorem ipsum dolor sit amet",
            subtitle: "Lorem ipsum dolor sit amet",
            grade: 5,
            type: "single",
            answers: [
              %{
                id: 1,
                title: "Lorem ipsum dolor sit amet",
                subtitle: "Lorem ipsum dolor sit amet",
                is_correct: true,
                correct_value: "Lorem ipsum dolor sit amet",
                sequence_order_number: 1
              }
            ]
          })
        end,
      Questions:
        swagger_schema do
          title("List of questions")
          description("A collection of Question")
          type(:array)
          items(Schema.ref(:Question))
        end,
      Quiz:
        swagger_schema do
          title("Quiz")
          description("A quiz object")

          properties do
            id(:number, "Unique identifier")
            title(:string, "Quiz title")
            description(:string, "Quiz description")
            estimation(:json, "Quiz estimation")
            lesson_id(:number, "Lesson id belongs to")
            questions(Schema.ref(:Questions), "List of quiz questions")
            inserted_at(:datetime, "Date and time of quiz creation")
            updated_at(:datetime, "Date and time of quiz last update")
          end

          example(%{
            id: 1,
            title: "Lorem ipsum dolor sit amet",
            description: "Lorem ipsum dolor sit amet",
            estimation: %{
              "great" => 9,
              "good" => 7,
              "normal" => 5
            },
            lesson_id: 1,
            questions: [
              %{
                id: 1,
                title: "Lorem ipsum dolor sit amet",
                subtitle: "Lorem ipsum dolor sit amet",
                grade: 5,
                type: "single",
                quiz_id: 1,
                answers: [
                  %{
                    id: 1,
                    title: "Lorem ipsum dolor sit amet",
                    subtitle: "Lorem ipsum dolor sit amet",
                    is_correct: true,
                    correct_value: "Lorem ipsum dolor sit amet",
                    sequence_order_number: 1
                  }
                ],
                inserted_at: "2024-07-11T05:47:50Z",
                updated_at: "2024-07-11T05:47:50Z"
              }
            ],
            inserted_at: "2024-07-11T05:47:50Z",
            updated_at: "2024-07-11T05:47:50Z"
          })
        end,
      Quizzes:
        swagger_schema do
          title("List of quizzes")
          description("A collection of Quiz")
          type(:array)
          items(Schema.ref(:Quiz))
        end,
      Pagination:
        swagger_schema do
          title("Pagination data")
          description("Pagination data to get classes by pages")

          properties do
            count(:number, "Total classes in the database")
            page(:number, "Current page")
            pages(:number, "Total pages")
            page_size(:number, "Page size, i.e. class count per page")
          end

          example(%{
            count: 10,
            page: 1,
            pages: 2,
            page_size: 5
          })
        end,
      QuizzesWithPagination:
        swagger_schema do
          title("List of quizzes with pagination data")
          description("A collection of Quizzes with pagination data")

          properties do
            list(Schema.ref(:Quizzes), "Quizzes list", required: true)
            pagination(Schema.ref(:Pagination), "Pagination data", required: true)
          end
        end,
      NewQuiz:
        swagger_schema do
          title("New quiz")
          description("Data object to create new quiz")

          properties do
            title(:string, "Quiz title", required: true)
            description(:string, "Quiz description")
            estimation(:string, "Quiz estimation")
            lesson_id(:number, "Lesson id belongs to", required: true)
          end

          example(%{
            title: "Lorem ipsum dolor sit amet",
            description: "Lorem ipsum dolor sit amet",
            estimation: %{
              "great" => 9,
              "good" => 7,
              "normal" => 5
            },
            lesson_id: 1
          })
        end,
      UpdateQuiz:
        swagger_schema do
          title("Update existing quiz")
          description("Data object to update quiz")

          properties do
            title(:string, "Quiz title")
            description(:string, "Quiz description")
            estimation(:string, "Quiz estimation")
            lesson_id(:number, "Lesson id belongs to")
          end

          example(%{
            title: "Lorem ipsum dolor sit amet",
            description: "Lorem ipsum dolor sit amet",
            estimation: %{
              "great" => 9,
              "good" => 7,
              "normal" => 5
            },
            lesson_id: 1
          })
        end
    }
  end

  swagger_path :index do
    get("/quizzes")
    summary("Query for quizzes")
    description("Query for all quizzes. This operation supports pagination.")
    produces("application/json")
    tag("Quizzes")

    parameters do
      page(:query, :number, "Page")
      page_size(:query, :number, "Page size")
      lesson_id(:query, :string, "Lesson id")
    end

    security([%{bearer: []}])

    response(200, "Success", Schema.ref(:QuizzesWithPagination))
  end

  def index(conn, params) do
    data = Quizzes.list_quizzes(params)
    render(conn, :index, data: data)
  end

  swagger_path :create do
    post("/quizzes")
    summary("Create new quiz")
    description("Create new quiz.")
    produces("application/json")
    tag("Quizzes")

    security([%{bearer: []}])

    parameters do
      quiz(:body, Schema.ref(:NewQuiz), "Data to create quiz", required: true)
    end

    response(201, "Success", Schema.ref(:Quiz))
    response(422, "Unprocessable entity (something wrong with body)")
    response(400, "Bad request (Unknown error)")
  end

  def create(conn, %{"quiz" => quiz_params}) do
    with {:ok, %Quiz{} = quiz} <- Quizzes.create_quiz(quiz_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/quizzes/#{quiz}")
      |> render(:show, quiz: quiz)
    end
  end

  swagger_path :show do
    get("/quizzes/{id}")
    summary("Query single quiz by id")
    description("Query single quiz by id.")
    produces("application/json")
    tag("Quizzes")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Quiz id", required: true)
    end

    response(200, "Success", Schema.ref(:Quiz))
    response(404, "Not found (quiz doesn't exists)")
    response(400, "Bad request (Unknown error)")
  end

  def show(conn, %{"id" => id}) do
    quiz = Quizzes.get_quiz!(id)
    render(conn, :show, quiz: quiz)
  end

  swagger_path :update do
    put("/quizzes/{id}")
    summary("Update existing quiz")
    description("Update existing quiz.")
    produces("application/json")
    tag("Quizzes")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Quiz id", required: true)
      quiz(:body, Schema.ref(:UpdateQuiz), "Data to update quiz", required: true)
    end

    response(200, "Success", Schema.ref(:Quiz))
    response(404, "Not found (quiz doesn't exists)")
    response(422, "Unprocessable entity (something wrong with body)")
    response(400, "Bad request (Unknown error)")
  end

  def update(conn, %{"id" => id, "quiz" => quiz_params}) do
    quiz = Quizzes.get_quiz!(id)

    with {:ok, %Quiz{} = quiz} <- Quizzes.update_quiz(quiz, quiz_params) do
      render(conn, :show, quiz: quiz)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/quizzes/{id}")
    summary("Delete quiz by id")
    description("Delete quiz by id.")
    tag("Quizzes")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Quiz id", required: true)
    end

    response(204, "No content (quiz deleted)")
    response(404, "Not found (quiz doesn't exists)")
    response(400, "Bad request (Unknown error)")
  end

  def delete(conn, %{"id" => id}) do
    quiz = Quizzes.get_quiz!(id)

    with {:ok, %Quiz{}} <- Quizzes.delete_quiz(quiz) do
      send_resp(conn, :no_content, "")
    end
  end

  swagger_path :create_question do
    post("/quizzes/{id}/questions")
    summary("Create new quiz question")
    description("Create new quiz question.")
    produces("application/json")
    tag("Quizzes")

    security([%{bearer: []}])

    parameters do
      question(:body, Schema.ref(:NewQuestion), "Data to create question", required: true)
    end

    response(201, "Success", Schema.ref(:Quiz))
    response(422, "Unprocessable entity (something wrong with body)")
    response(400, "Bad request (Unknown error)")
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

  swagger_path :update_question do
    put("/quizzes/{id}/questions/{question_id}")
    summary("Update existing question")
    description("Update existing question.")
    produces("application/json")
    tag("Quizzes")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Question id", required: true)
      quiz(:body, Schema.ref(:UpdateQuestion), "Data to update question", required: true)
    end

    response(200, "Success", Schema.ref(:Quiz))
    response(404, "Not found (question doesn't exists)")
    response(422, "Unprocessable entity (something wrong with body)")
    response(400, "Bad request (Unknown error)")
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

  swagger_path :delete_question do
    PhoenixSwagger.Path.delete("/quizzes/{id}/questions/{question_id}")
    summary("Delete questions by id")
    description("Delete questions by id.")
    tag("Quizzes")

    security([%{bearer: []}])

    parameters do
      id(:path, :number, "Question id", required: true)
    end

    response(204, "No content (question deleted)")
    response(404, "Not found (question doesn't exists)")
    response(400, "Bad request (Unknown error)")
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
