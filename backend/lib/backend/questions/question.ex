defmodule Backend.Questions.Question do
  defmodule Answer do
    @enforce_keys [:id, :title, :is_correct]
    defstruct [:id, :title, :subtitle, :is_correct, :correct_value, :sequence_order_number]
  end

  use Ecto.Schema
  import Ecto.Changeset

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
    field(:answers, {:array, :map})
    belongs_to(:quiz, Backend.Quizzes.Quiz)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:title, :subtitle, :type, :grade, :answers])
    |> validate_required([:title, :type])
  end
end
