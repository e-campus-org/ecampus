defmodule Backend.Repo.Migrations.CreateSpecialities do
  use Ecto.Migration

  def change do
    create table(:specialities) do
      add :code, :string
      add :title, :string
      add :description, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:specialities, [:code])
  end
end
