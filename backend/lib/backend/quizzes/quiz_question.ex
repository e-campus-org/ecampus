defmodule Backend.Quizzes.QuizQuestion do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "quizzes_questions" do
    belongs_to(:questions, Backend.Quizzes.Question,
      foreign_key: :question_id,
      primary_key: true
    )

    belongs_to(:quizzes, Backend.Quizzes.Quiz, foreign_key: :quiz_id, primary_key: true)

    field(:order, :integer)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(quiz_question, attrs) do
    quiz_question
    |> cast(attrs, [:question_id, :quiz_id])
    |> validate_required([:question_id, :quiz_id])
    |> foreign_key_constraint(:quiz_id)
    |> foreign_key_constraint(:question_id)
  end
end
