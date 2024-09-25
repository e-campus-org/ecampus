defmodule Backend.Repo.Migrations.CreateLessonsPolls do
  use Ecto.Migration

  def change do
    create table(:lessons_polls) do
      add :lesson_id, references(:lessons, on_delete: :nothing)
      add :poll_id, references(:polls, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:lessons_polls, [:lesson_id])
    create index(:lessons_polls, [:poll_id])
  end
end
