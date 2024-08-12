defmodule Backend.Lessons.Lesson do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:title, :topic, :is_draft, :subject_id], sortable: [:title, :topic, :is_draft]
  }

  schema "lessons" do
    field(:description, :string)
    field(:title, :string)
    field(:topic, :string)
    field(:is_draft, :boolean, default: true)
    field(:hours_count, :integer, default: 2)
    belongs_to(:subject, Backend.Subjects.Subject)
    has_many(:topics, Backend.LessonTopics.LessonTopic)
    has_many(:classes, Backend.Classes.Class)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(lesson, attrs) do
    lesson
    |> cast(attrs, [:title, :description, :topic, :is_draft, :subject_id, :hours_count])
    |> validate_required([:title, :topic, :subject_id])
    |> foreign_key_constraint(:subject_id)
  end
end
