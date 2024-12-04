defmodule Backend.Groups.Group do
  @moduledoc """
  Group schema module
  """

  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:description, :title, :speciality_id], sortable: [:description, :title]
  }

  schema "groups" do
    field(:description, :string)
    field(:title, :string)
    belongs_to(:speciality, Backend.Specialities.Speciality)
    has_many(:accounts, Backend.Accounts.Account)
    has_many(:classes, Backend.Classes.Class)
    many_to_many(:subjects, Backend.Subjects.Subject, join_through: "taught_subjects")
    many_to_many(:teachers, Backend.Accounts.Account, join_through: "taught_subjects")
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
