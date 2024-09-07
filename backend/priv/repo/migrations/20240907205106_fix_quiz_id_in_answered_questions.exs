defmodule Backend.Repo.Migrations.FixQuizIdInAnsweredQuestions do
  use Ecto.Migration

  def change do
    alter table(:answered_questions, primary_key: false) do
      remove(:quiz_id)
      remove(:student_id)
      remove(:question_id)
      add(:student_id, references(:accounts, on_delete: :nothing), primary_key: true)
      add(:question_id, references(:questions, on_delete: :nothing), primary_key: true)
      add(:quiz_id, references(:quizzes, on_delete: :nothing))
    end
  end
end
