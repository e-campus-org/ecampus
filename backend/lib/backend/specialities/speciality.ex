defmodule Backend.Specialities.Speciality do
  @moduledoc """
  Speciality schema module
  """

  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:description, :title, :code], sortable: [:description, :title, :code]
  }

  schema "specialities" do
    field :code, :string
    field :description, :string
    field :title, :string
    has_many :groups, Backend.Groups.Group
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(speciality, attrs) do
    speciality
    |> cast(attrs, [:code, :title, :description])
    |> validate_required([:code, :title, :description])
    |> unique_constraint(:code)
  end
end
