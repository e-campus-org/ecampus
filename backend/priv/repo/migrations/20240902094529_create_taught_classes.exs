defmodule Backend.Repo.Migrations.CreateTaughtClasses do
  use Ecto.Migration

  def change do
    create table(:taught_classes) do
      add(:comment, :text)
      add(:taught_by_id, references(:accounts, on_delete: :nothing))
      add(:class_id, references(:classes, on_delete: :nothing))

      timestamps(type: :utc_datetime)
    end

    create(index(:taught_classes, [:taught_by_id]))
    create(index(:taught_classes, [:class_id]))
  end
end
