defmodule Backend.Repo.Migrations.CreateLessonTopics do
  use Ecto.Migration

  def change do
    create table(:lesson_topics) do
      add(:title, :string)
      add(:content, :text)
      add(:description, :text)
      add(:objectives, :text)
      add(:lesson_id, references(:lessons, on_delete: :nothing))

      timestamps(type: :utc_datetime)
    end
  end
end
