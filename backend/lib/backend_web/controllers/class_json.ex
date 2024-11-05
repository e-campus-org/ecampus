defmodule BackendWeb.ClassJSON do
  alias Backend.Classes.Class
  alias Backend.LessonTopics.LessonTopic
  alias Backend.Quizzes.Quiz
  alias Backend.Quizzes.Question
  alias Backend.Quizzes.Answer
  alias Backend.Accounts.Account
  alias Backend.Quizzes.AnsweredQuestion

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
        topics: for(topic <- class.lesson.topics, do: data_topic(topic)),
        quizzes: for(quiz <- class.lesson.quizzes, do: data_quiz(quiz)),
        teachers: for(teacher <- class.lesson.subject.teachers, do: data_account(teacher))
      },
      teachers: for(teacher <- class.teachers, do: data_account(teacher)),
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

  defp data_quiz(%Quiz{} = quiz) do
    %{
      id: quiz.id,
      title: quiz.title,
      description: quiz.description,
      lesson_id: quiz.lesson_id,
      questions: for(question <- quiz.questions, do: data_question(question, quiz.id))
    }
  end

  defp data_question(%Question{} = question, quiz_id) do
    %{
      id: question.id,
      type: question.type,
      title: question.title,
      order:
        case question.quizzes_questions
             |> Enum.find(fn qq -> qq.quiz_id == quiz_id end) do
          %{order: order} -> order
          _ -> 1
        end,
      subtitle:
        case {question.answered_questions, question.show_correct_answer} do
          {[_ | _], true} -> question.subtitle
          _ -> nil
        end,
      grade: question.grade,
      answers:
        for(
          answer <- question.answers,
          do:
            data_answer(
              answer,
              length(question.answered_questions) > 0 and question.show_correct_answer
            )
        ),
      your_answer:
        for(
          answered_question <- question.answered_questions,
          do: data_answered_question(answered_question, question.show_correct_answer)
        )
    }
  end

  defp data_answer(%Answer{} = answer, show_subtitle) do
    %{
      id: answer.id,
      title: answer.title,
      subtitle:
        case show_subtitle do
          true -> answer.subtitle
          _ -> nil
        end
    }
  end

  defp data_answered_question(%AnsweredQuestion{} = answer, true), do: answer.answer

  defp data_answered_question(%AnsweredQuestion{} = answer, false),
    do: %{answer_id: Map.get(answer.answer, "answer_id"), grade: Map.get(answer.answer, "grade")}

  defp data_account(%Account{} = account) do
    %{
      id: account.id,
      first_name: account.first_name,
      last_name: account.last_name
    }
  end
end
