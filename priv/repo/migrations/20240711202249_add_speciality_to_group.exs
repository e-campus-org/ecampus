defmodule Backend.Repo.Migrations.AddSpecialityToGroup do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      add :speciality_id, references(:specialities)
    end
  end
end
