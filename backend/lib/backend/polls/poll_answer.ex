defmodule Backend.Polls.PollAnswer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "poll_answers" do
    field :title, :string
    field :subtitle, :string
    belongs_to :poll_question, Backend.Polls.PollQuestion

    has_many :poll_answers, Backend.Polls.PollAnswer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(poll_answer, attrs, required \\ true) do
    poll_answer
    |> cast(attrs, [:title, :subtitle, :poll_question_id])
    |> maybe_validate_required(required)
    |> foreign_key_constraint(:poll_question_id)
  end

  defp maybe_validate_required(changeset, true) do
    changeset
    |> validate_required([:title, :poll_question_id])
  end

  defp maybe_validate_required(changeset, false), do: changeset
end
