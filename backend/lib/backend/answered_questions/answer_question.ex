defmodule Backend.AnsweredQuestions.AnsweredQuestion do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "answered_questions" do
    field(:answer, :map)

    belongs_to(:accounts, Backend.Accounts.Account,
      foreign_key: :student_id,
      primary_key: true
    )

    belongs_to(:questions, Backend.Questions.Question,
      foreign_key: :question_id,
      primary_key: true
    )

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(answer_question, attrs) do
    answer_question
    |> cast(attrs, [:answer, :student_id, :question_id])
    |> validate_required([:student_id, :question_id])
    |> foreign_key_constraint(:student_id)
    |> foreign_key_constraint(:question_id)
    |> unique_constraint([:student_id, :question_id], name: :answered_questions_pkey)
  end
end
