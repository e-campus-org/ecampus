defmodule Backend.Repo.Migrations.Roles do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add(:roles, {:array, :string}, null: false, default: ["student"])
    end
  end
end
