defmodule Backend.Repo.Migrations.ConnectAccountsWithGroups do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :group_id, references(:groups)
    end

    create unique_index(:accounts, [:email])
  end
end
