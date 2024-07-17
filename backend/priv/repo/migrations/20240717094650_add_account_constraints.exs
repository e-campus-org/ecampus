defmodule Backend.Repo.Migrations.AddAccountConstraints do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      modify(:email, :string, null: false)
      modify(:password_hash, :string, null: false)
    end
  end
end
