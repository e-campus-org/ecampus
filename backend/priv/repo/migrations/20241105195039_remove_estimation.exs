defmodule Backend.Repo.Migrations.RemoveEstimation do
  use Ecto.Migration

  def change do
    alter table(:quizzes) do
      remove(:estimation)
    end
  end
end
