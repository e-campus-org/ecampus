defmodule Backend.Repo.Migrations.CreateAnsweredQuestions do
  use Ecto.Migration

  def change do
    create table(:answered_questions, primary_key: false) do
      add(:answer, :map)
      add(:student_id, references(:accounts, on_delete: :nothing), primary_key: true)
      add(:question_id, references(:questions, on_delete: :nothing), primary_key: true)

      timestamps(type: :utc_datetime)
    end

    create(index(:answered_questions, [:student_id]))
    create(index(:answered_questions, [:question_id]))
  end
end
