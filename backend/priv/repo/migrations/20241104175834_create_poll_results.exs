defmodule Backend.Repo.Migrations.CreatePollResults do
  use Ecto.Migration

  def change do
    create table(:poll_results) do
      add :open_question_text, :string
      add :poll_questions_id, references(:poll_questions, on_delete: :nothing)
      add :poll_answers_id, references(:poll_answers, on_delete: :nothing)
      add :accounts_id, references(:accounts, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:poll_results, [:poll_questions_id])
    create index(:poll_results, [:poll_answers_id])
    create index(:poll_results, [:accounts_id])
  end
end
