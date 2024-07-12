defmodule Backend.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :title, :string
      add :description, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:groups, [:title])
  end
end
