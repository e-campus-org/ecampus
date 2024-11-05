defmodule Backend.Quizzes.Quiz do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:title, :description, :lesson_id], sortable: [:title, :lesson_id]
  }

  schema "quizzes" do
    field(:description, :string)
    field(:title, :string)
    field(:estimation, :map)
    belongs_to(:lesson, Backend.Lessons.Lesson)

    many_to_many(:questions, Backend.Quizzes.Question,
      join_through: "quizzes_questions",
      join_keys: [quiz_id: :id, question_id: :id]
    )

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(quiz, attrs) do
    quiz
    |> cast(attrs, [:title, :description, :estimation, :lesson_id])
    |> validate_required([:title, :lesson_id])
    |> foreign_key_constraint(:lesson_id)
  end
end
