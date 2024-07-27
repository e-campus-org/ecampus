defmodule Backend.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:description, :title, :speciality_id], sortable: [:description, :title]
  }

  schema "groups" do
    field :description, :string
    field :title, :string
    belongs_to :speciality, Backend.Specialities.Speciality
    has_many :accounts, Backend.Accounts.Account
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:title, :description, :speciality_id])
    |> validate_required([:title, :description])
    |> unique_constraint(:title)
    |> foreign_key_constraint(:speciality_id)
  end
end
