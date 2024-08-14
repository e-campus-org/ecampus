defmodule Backend.Repo.Migrations.AddObjectivesToLessonAndRemoveDescription do
  use Ecto.Migration

  def change do
    rename(table(:lessons), :description, to: :objectives)
  end
end
