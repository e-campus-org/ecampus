defmodule Backend.LessonsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Lessons` context.
  """

  @doc """
  Generate a lesson.
  """
  def lesson_fixture(attrs \\ %{}) do
    {:ok, lesson} =
      attrs
      |> Enum.into(%{
        description: "some description",
        is_draft: true,
        title: "some title",
        topic: "some topic"
      })
      |> Backend.Lessons.create_lesson()

    lesson
  end
end
