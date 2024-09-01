defmodule Backend.Repo.Migrations.CreateQuizzes do
  use Ecto.Migration

  def change do
    create table(:quizzes) do
      add(:title, :string)
      add(:description, :string)
      add(:estimation, :map)
      add(:lesson_id, references(:lessons, on_delete: :nothing))

      timestamps(type: :utc_datetime)
    end

    create table(:questions) do
      add(:title, :text)
      add(:subtitle, :text)
      add(:type, :string)
      add(:grade, :integer)
      add(:answers, :map)
      add(:quiz_id, references(:quizzes, on_delete: :nothing))

      timestamps(type: :utc_datetime)
    end
  end
end
