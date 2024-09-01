defmodule Backend.QuestionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Questions` context.
  """

  @doc """
  Generate a question.
  """
  def question_fixture(attrs \\ %{}) do
    {:ok, question} =
      attrs
      |> Enum.into(%{
        answers: %{},
        grade: 42,
        subtitle: "some subtitle",
        title: "some title",
        type: :single
      })
      |> Backend.Questions.create_question()

    question
  end
end
