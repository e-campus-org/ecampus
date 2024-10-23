defmodule Backend.Repo.Migrations.CreatePollQuestions do
  use Ecto.Migration

  def change do
    create table(:poll_questions) do
      add :title, :string
      add :subtitle, :string
      add :type, :string
      add :poll_id, references(:polls, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:poll_questions, [:poll_id])
  end
end
