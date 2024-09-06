defmodule Backend.Repo.Migrations.QuizzesQuestionsPk do
  use Ecto.Migration

  def change do
    alter table(:quizzes_questions, primary_key: false) do
      remove(:id)
      modify(:quiz_id, :integer, primary_key: true)
      modify(:question_id, :integer, primary_key: true)
    end
  end
end
