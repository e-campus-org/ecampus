defmodule Backend.Repo.Migrations.AddQuestionsPerAttempt do
  use Ecto.Migration

  def change do
    alter table(:quizzes) do
      add(:questions_per_attempt, :integer, default: 0, notnull: true)
    end
  end
end
