defmodule Backend.Repo.Migrations.AddSortOrderUniqueIndex do
  use Ecto.Migration

  def change do
    create(unique_index(:lessons, [:subject_id, :sort_order]))
    create(unique_index(:lesson_topics, [:lesson_id, :sort_order]))
  end
end
