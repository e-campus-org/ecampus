defmodule Backend.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backend.Questions.Answer

  @derive {
    Flop.Schema,
    filterable: [:title, :subtitle, :quiz_id, :type],
    sortable: [:title, :subtitle, :quiz_id, :type]
  }

  schema "questions" do
    field(:type, Ecto.Enum, values: [:single, :multiple, :open, :sequence, :fill])
    field(:title, :string)
    field(:subtitle, :string)
    field(:grade, :integer)
    has_many(:answers, Backend.Questions.Answer)
    belongs_to(:quiz, Backend.Quizzes.Quiz)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:title, :subtitle, :type, :grade, :quiz_id])
    |> cast_assoc(:answers, with: &Answer.changeset/2)
    |> validate_required([:title, :type, :quiz_id])
    |> foreign_key_constraint(:quiz_id)
  end
end
