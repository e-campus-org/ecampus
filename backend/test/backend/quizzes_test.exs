defmodule Backend.QuizzesTest do
  use Backend.DataCase

  alias Backend.Quizzes

  describe "quizzes" do
    alias Backend.Quizzes.Quiz

    import Backend.QuizzesFixtures

    @invalid_attrs %{description: nil, title: nil}

    test "list_quizzes/0 returns all quizzes" do
      quiz = quiz_fixture()
      assert Quizzes.list_quizzes() == [quiz]
    end

    test "get_quiz!/1 returns the quiz with given id" do
      quiz = quiz_fixture()
      assert Quizzes.get_quiz!(quiz.id) == quiz
    end

    test "create_quiz/1 with valid data creates a quiz" do
      valid_attrs = %{description: "some description", title: "some title"}

      assert {:ok, %Quiz{} = quiz} = Quizzes.create_quiz(valid_attrs)
      assert quiz.description == "some description"
      assert quiz.title == "some title"
    end

    test "create_quiz/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Quizzes.create_quiz(@invalid_attrs)
    end

    test "update_quiz/2 with valid data updates the quiz" do
      quiz = quiz_fixture()

      update_attrs = %{
        description: "some updated description",
        title: "some updated title"
      }

      assert {:ok, %Quiz{} = quiz} = Quizzes.update_quiz(quiz, update_attrs)
      assert quiz.description == "some updated description"
      assert quiz.title == "some updated title"
    end

    test "update_quiz/2 with invalid data returns error changeset" do
      quiz = quiz_fixture()
      assert {:error, %Ecto.Changeset{}} = Quizzes.update_quiz(quiz, @invalid_attrs)
      assert quiz == Quizzes.get_quiz!(quiz.id)
    end

    test "delete_quiz/1 deletes the quiz" do
      quiz = quiz_fixture()
      assert {:ok, %Quiz{}} = Quizzes.delete_quiz(quiz)
      assert_raise Ecto.NoResultsError, fn -> Quizzes.get_quiz!(quiz.id) end
    end

    test "change_quiz/1 returns a quiz changeset" do
      quiz = quiz_fixture()
      assert %Ecto.Changeset{} = Quizzes.change_quiz(quiz)
    end
  end
end
