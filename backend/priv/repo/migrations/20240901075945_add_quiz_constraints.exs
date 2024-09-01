defmodule Backend.Repo.Migrations.AddQuizConstraints do
  use Ecto.Migration

  def change do
    alter table(:quizzes) do
      modify(:title, :string, null: false)
    end

    alter table(:questions) do
      modify(:title, :string, null: false)
      modify(:type, :string, null: false, default: "single")
    end
  end
end
