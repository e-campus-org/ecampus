defmodule Backend.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :description, :string
    field :title, :string
    has_many :accounts, Backend.Accounts.Account
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
    |> unique_constraint(:title)
  end
end
