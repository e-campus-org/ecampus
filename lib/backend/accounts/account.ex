defmodule Backend.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :email, :string
    field :last_name, :string
    field :first_name, :string
    belongs_to :group, Backend.Groups.Group
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :last_name, :first_name, :group_id])
    |> validate_required([:email, :last_name, :first_name])
    |> unique_constraint(:email)
    |> foreign_key_constraint(:group_id)
  end
end
