defmodule Backend.Polls.PollResult do
  use Ecto.Schema
  import Ecto.Changeset

  schema "poll_results" do
    field :open_question_text, :string

    belongs_to :poll_questions, Backend.Polls.PollQuestion
    belongs_to :poll_answers, Backend.Polls.PollAnswer
    belongs_to :accounts, Backend.Accounts.Account

    timestamps(type: :utc_datetime)
  end

  def single_changeset(poll_result, attrs) do
    attrs =
      attrs
      |> Map.put("poll_answers_id", Map.get(attrs, "answer_id"))
      |> Map.delete("answer_id")

    poll_result
    |> cast(attrs, [:poll_questions_id, :poll_answers_id, :accounts_id])
    |> validate_required([:poll_questions_id, :poll_answers_id, :accounts_id])
  end

  def multiple_changeset(poll_result, attrs) do
    with {:ok, answer_ids} <- Map.fetch(attrs, "answer_ids") do
      Enum.map(answer_ids, fn answer_id ->
        single_changeset(poll_result, Map.put(attrs, "answer_id", answer_id))
      end)
    end
  end

  def open_changeset(poll_result, attrs) do
    attrs =
      attrs
      |> Map.put("open_question_text", Map.get(attrs, "text"))
      |> Map.delete("text")

    poll_result
    |> cast(attrs, [:poll_questions_id, :open_question_text, :accounts_id])
    |> validate_required([:poll_questions_id, :open_question_text, :accounts_id])
  end
end
