defmodule Backend.Repo.Migrations.AddHoursToLessons do
  use Ecto.Migration

  def change do
    alter table(:lessons) do
      add(:hours_count, :integer, default: 2)
    end
  end
end
