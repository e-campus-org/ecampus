defmodule Backend.Repo.Migrations.CreateQuizzesQuestions do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      remove(:quiz_id)
      remove(:answers)
    end

    create table(:quizzes_questions) do
      add(:quiz_id, references(:quizzes, on_delete: :nothing))
      add(:question_id, references(:questions, on_delete: :nothing))

      timestamps(type: :utc_datetime)
    end

    create(index(:quizzes_questions, [:quiz_id]))
    create(index(:quizzes_questions, [:question_id]))
  end
end
