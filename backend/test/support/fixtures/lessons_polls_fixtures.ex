defmodule Backend.LessonsPollsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.LessonsPolls` context.
  """

  @doc """
  Generate a lesson_poll.
  """
  def lesson_poll_fixture(attrs \\ %{}) do
    {:ok, lesson_poll} =
      attrs
      |> Enum.into(%{

      })
      |> Backend.LessonsPolls.create_lesson_poll()

    lesson_poll
  end
end
