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
  def changeset(poll, attrs, required \\ true) do
    poll
    |> cast(attrs, [:title, :description])
    |> maybe_validate_required(required)
  end

  defp maybe_validate_required(changeset, true) do
    changeset
    |> validate_required([:title])
  end

  defp maybe_validate_required(changeset, false), do: changeset
end
