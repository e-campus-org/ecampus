defmodule Backend.Repo.Migrations.CreateTaughtSubjects do
  use Ecto.Migration

  def change do
    create table(:taught_subjects) do
      add(:taught_by_id, references(:accounts))
      add(:group_id, references(:groups))
      add(:subject_id, references(:subjects))
      add(:comment, :string)

      timestamps(type: :utc_datetime)
    end

    create(index(:taught_subjects, [:taught_by_id]))
    create(index(:taught_subjects, [:group_id]))
    create(index(:taught_subjects, [:subject_id]))
  end
end
