defmodule Backend.Specialities.Speciality do
  use Ecto.Schema
  import Ecto.Changeset

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
