defmodule Backend.Polls.PollAnswer do
  @moduledoc """
  PollAnswer schema module
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "poll_answers" do
    field :title, :string
    field :subtitle, :string
    belongs_to :poll_question, Backend.Polls.PollQuestion

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(poll_answer, attrs) do
    poll_answer
    |> cast(attrs, [:title, :subtitle])
    |> validate_required([:title])
    |> foreign_key_constraint(:poll_question_id)
  end
end
