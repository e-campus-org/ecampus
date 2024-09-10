defmodule Backend.Repo.Migrations.AddQuestionOrderField do
  use Ecto.Migration

  def change do
    alter table(:quizzes_questions) do
      add(:order, :integer, default: 1, notnull: true)
    end
  end
end
