defmodule Backend.Repo.Migrations.AddShowCorrectAnswerField do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      add(:show_correct_answer, :boolean, default: true)
    end
  end
end
