defmodule Backend.Polls.PollQuestion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "poll_questions" do
    field :type, Ecto.Enum, values: [:single, :multiple, :open]
    field :title, :string
    field :subtitle, :string
    belongs_to :poll, Backend.Polls.Poll

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(poll_question, attrs, required \\ true) do
    poll_question
    |> cast(attrs, [:title, :subtitle, :type, :poll_id])
    |> maybe_validate_required(required)
  end

  defp maybe_validate_required(changeset, true) do
    changeset
    |> validate_required([:title])
  end

  defp maybe_validate_required(changeset, false), do: changeset
end
