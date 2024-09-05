defmodule Backend.Repo.Migrations.CascadeDeleteAnswers do
  use Ecto.Migration

  def change do
    drop(constraint(:answers, :answers_question_id_fkey))

    alter table(:answers) do
      modify(:question_id, references(:questions, on_delete: :delete_all))
    end
  end
end
