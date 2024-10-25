defmodule Backend.Repo.Migrations.AddSortOrderField do
  use Ecto.Migration

  def change do
    alter table(:lessons) do
      add(:sort_order, :integer, default: 0, notnull: true)
    end

    alter table(:lesson_topics) do
      add(:sort_order, :integer, default: 0, notnull: true)
    end
  end
end
