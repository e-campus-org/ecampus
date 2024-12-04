defmodule Backend.LessonTopics.LessonTopic do
  @moduledoc """
  LessonTopic schema module
  """

  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:title, :lesson_id], sortable: [:title]
  }

  schema "lesson_topics" do
    field(:title, :string)
    field(:content, :map)
    field(:sort_order, :integer, default: 0)
    belongs_to(:lesson, Backend.Lessons.Lesson)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(lesson_topic, attrs) do
    lesson_topic
    |> cast(attrs, [:title, :content, :lesson_id, :sort_order])
    |> validate_required([:title, :lesson_id, :sort_order])
    |> foreign_key_constraint(:lesson_id)
    |> unique_constraint([:sort_order, :lesson_id],
      name: :lesson_topics_lesson_id_sort_order_index
    )
  end
end
