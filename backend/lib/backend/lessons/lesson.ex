defmodule Backend.Lessons.Lesson do
  @moduledoc """
  Lesson schema module
  """
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:title, :topic, :is_draft, :subject_id], sortable: [:title, :topic, :is_draft]
  }

  schema "lessons" do
    field(:objectives, :string)
    field(:title, :string)
    field(:topic, :string)
    field(:is_draft, :boolean, default: true)
    field(:hours_count, :integer, default: 2)
    field(:sort_order, :integer, default: 0)
    belongs_to(:subject, Backend.Subjects.Subject)
    has_many(:quizzes, Backend.Quizzes.Quiz)
    has_many(:topics, Backend.LessonTopics.LessonTopic)
    has_many(:classes, Backend.Classes.Class)

    many_to_many(:lessons, Backend.Polls.Poll,
      join_through: "lessons_polls",
      join_keys: [poll_id: :id, lesson_id: :id]
    )

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(lesson, attrs) do
    lesson
    |> cast(attrs, [
      :title,
      :objectives,
      :topic,
      :is_draft,
      :subject_id,
      :hours_count,
      :sort_order
    ])
    |> validate_required([:title, :topic, :subject_id, :sort_order])
    |> foreign_key_constraint(:subject_id)
    |> unique_constraint([:sort_order, :subject_id], name: :lessons_subject_id_sort_order_index)
  end
end
