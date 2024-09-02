defmodule Backend.Questions.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:title, :subtitle, :question_id],
    sortable: [:question_id, :sequence_order_number]
  }

  schema "answers" do
    field(:title, :string)
    field(:subtitle, :string)
    field(:is_correct, :boolean, default: false)
    field(:correct_value, :string)
    field(:sequence_order_number, :integer)
    belongs_to(:question, Backend.Questions.Question)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [
      :title,
      :subtitle,
      :is_correct,
      :correct_value,
      :sequence_order_number,
      :question_id
    ])
    |> validate_required([:title, :subtitle, :is_correct])
    |> foreign_key_constraint(:question_id)
  end
end
