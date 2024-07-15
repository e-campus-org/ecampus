defmodule Backend.Repo.Migrations.AddPasswordHash do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add(:password_hash, :string)
    end
  end
end
