defmodule Backend.Lessons.Lesson do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:title, :topic, :is_draft], sortable: [:title, :topic, :is_draft]
  }

  schema "lessons" do
    field(:description, :string)
    field(:title, :string)
    field(:topic, :string)
    field(:is_draft, :boolean, default: true)
    belongs_to(:subject, Backend.Subjects.Subject)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(lesson, attrs) do
    lesson
    |> cast(attrs, [:title, :description, :topic, :is_draft, :subject_id])
    |> validate_required([:title, :topic, :subject_id])
  end
end
