defmodule Backend.QuestionFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Question` context.
  """

  @doc """
  Generate a question.
  """
  def question_fixture(attrs \\ %{}) do
    quiz = Map.get(attrs, :quiz)

    question_attrs =
      attrs
      |> Map.delete(:quiz)
      |> Enum.into(%{
        subtitle: "some subtitle",
        title: "some title",
        grade: 10,
        type: :single,
        show_correct_answer: true,
        answers: []
      })
      |> Enum.map(fn {key, value} -> {Atom.to_string(key), value} end)
      |> Enum.into(%{})

    question =
      Backend.Quizzes.create_question(Map.put(question_attrs, "quiz_id", quiz && quiz.id))

    question
  end
end
