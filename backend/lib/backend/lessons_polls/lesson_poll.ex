defmodule Backend.LessonsPolls.LessonPoll do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lessons_polls" do
    belongs_to(:lessons, Backend.Lessons.Lesson, foreign_key: :lesson_id)

    belongs_to(:polls, Backend.Polls.Poll, foreign_key: :poll_id)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(lesson_poll, attrs) do
    lesson_poll
    |> cast(attrs, [])
    |> validate_required([])
  end
end
