defmodule Backend.Polls.Poll do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:title, :description], sortable: [:title]
  }

  schema "polls" do
    field(:description, :string)
    field(:title, :string)

    many_to_many(:lessons, Backend.Lessons.Lesson,
      join_through: "lessons_polls",
      join_keys: [lesson_id: :id, poll_id: :id]
    )

    has_many :poll_questions, Backend.Polls.PollQuestion

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(poll, attrs) do
    poll
    |> cast(attrs, [:title, :description])
    |> validate_required([:title])
  end
end
