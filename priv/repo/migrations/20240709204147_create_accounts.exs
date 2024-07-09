defmodule Backend.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :email, :string
      add :last_name, :string
      add :first_name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
