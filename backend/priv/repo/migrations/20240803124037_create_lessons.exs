defmodule Backend.Repo.Migrations.CreateLessons do
  use Ecto.Migration

  def change do
    create table(:lessons) do
      add(:title, :string)
      add(:description, :text)
      add(:topic, :text)
      add(:is_draft, :boolean, default: false, null: false)
      add(:subject_id, references(:subjects, on_delete: :nothing))

      timestamps(type: :utc_datetime)
    end

    create(index(:lessons, [:subject_id]))
  end
end
