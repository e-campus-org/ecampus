defmodule Backend.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add(:title, :string)
      add(:subtitle, :string)
      add(:is_correct, :boolean, default: false, null: false)
      add(:correct_value, :string)
      add(:sequence_order_number, :integer)
      add(:question_id, references(:questions, on_delete: :nothing))

      timestamps(type: :utc_datetime)
    end
  end
end
