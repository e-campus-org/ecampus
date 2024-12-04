defmodule Backend.QuizzesTest do
  use Backend.DataCase

  alias Backend.Quizzes

  import Backend.QuizzesFixtures

  import Backend.LessonsFixtures

  import Backend.SubjectsFixtures

  import Backend.QuestionFixtures

  describe "quizzes" do
    @invalid_attrs %{description: nil, title: nil, lesson_id: nil, questions_per_attempt: nil}

    test "list_quizzes/0 returns all quizzes" do
      quiz = create_quiz()
      {:ok, %{list: list}} = Quizzes.list_quizzes()
      assert list == [quiz]
    end

    test "get_quiz!/1 returns the quiz with given id" do
      quiz = create_quiz()
      assert Quizzes.get_quiz!(quiz.id) == quiz
    end

    test "create_quiz/1 with valid data creates a quiz" do
      %{id: lesson_id} = create_lesson()

      valid_attrs = %{
        description: "some description",
        title: "some title",
        questions_per_attempt: 10,
        lesson_id: lesson_id
      }

      assert {:ok, %{} = quiz} = Quizzes.create_quiz(valid_attrs)
      assert quiz.description == valid_attrs.description
      assert quiz.title == valid_attrs.title
      assert quiz.questions_per_attempt == valid_attrs.questions_per_attempt
      assert quiz.lesson_id == valid_attrs.lesson_id
    end

    test "create_quiz/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Quizzes.create_quiz(@invalid_attrs)
    end

    test "update_quiz/2 with valid data updates the quiz" do
      quiz = create_quiz()
      lesson = create_lesson()

      update_attrs = %{
        description: "some updated description",
        title: "some updated title",
        questions_per_attempt: 15,
        lesson_id: lesson.id
      }

      assert {:ok, %{} = quiz} = Quizzes.update_quiz(quiz, update_attrs)
      assert quiz.description == update_attrs.description
      assert quiz.title == update_attrs.title
      assert quiz.questions_per_attempt == update_attrs.questions_per_attempt
      assert quiz.lesson_id == update_attrs.lesson_id
    end

    test "update_quiz/2 with invalid data returns error changeset" do
      quiz = create_quiz()
      assert {:error, %Ecto.Changeset{}} = Quizzes.update_quiz(quiz, @invalid_attrs)
      assert quiz == Quizzes.get_quiz!(quiz.id)
    end

    test "delete_quiz/1 deletes the quiz" do
      quiz = create_quiz()
      assert {:ok, %{}} = Quizzes.delete_quiz(quiz)
      assert_raise Ecto.NoResultsError, fn -> Quizzes.get_quiz!(quiz.id) end
    end

    test "get_question!/1 returns the question with given id" do
      quiz = create_quiz()
      question = question_fixture(%{quiz: quiz})
      assert Quizzes.get_question!(question.id) == question
    end
  end

  defp create_lesson() do
    subject = subject_fixture()
    lesson_fixture(%{subject_id: subject.id})
  end

  defp create_quiz() do
    subject = subject_fixture()
    lesson = lesson_fixture(%{subject_id: subject.id})
    quiz_fixture(%{lesson_id: lesson.id})
  end

  defp create_question() do
    subject = subject_fixture()
    lesson = lesson_fixture(%{subject_id: subject.id})
    quiz = quiz_fixture(%{lesson_id: lesson.id})
    question_fixture()
  end
end
