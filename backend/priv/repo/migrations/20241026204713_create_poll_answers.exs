defmodule Backend.Repo.Migrations.CreatePollAnswers do
  use Ecto.Migration

  def change do
    create table(:poll_answers) do
      add :title, :string
      add :subtitle, :string
      add :poll_question_id, references(:poll_questions, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:poll_answers, [:poll_question_id])
  end
end
