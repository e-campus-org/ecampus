defmodule Backend.LessonTopicsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.LessonTopics` context.
  """

  @doc """
  Generate a lesson_topic.
  """
  def lesson_topic_fixture(attrs \\ %{}) do
    {:ok, lesson_topic} =
      attrs
      |> Enum.into(%{
        content: "some content",
        title: "some title"
      })
      |> Backend.LessonTopics.create_lesson_topic()

    lesson_topic
  end
end
