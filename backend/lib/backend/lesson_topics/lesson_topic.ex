defmodule Backend.LessonTopics.LessonTopic do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:title, :lesson_id], sortable: [:description, :title]
  }

  schema "lesson_topics" do
    field(:title, :string)
    field(:description, :string)
    field(:objectives, :string)
    field(:content, :string)
    belongs_to(:lesson, Backend.Lessons.Lesson)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(lesson_topic, attrs) do
    lesson_topic
    |> cast(attrs, [:title, :content, :description, :objectives, :lesson_id])
    |> validate_required([:title, :lesson_id])
    |> foreign_key_constraint(:lesson_id)
  end
end
