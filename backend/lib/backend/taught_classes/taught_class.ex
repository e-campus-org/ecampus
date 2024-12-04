defmodule Backend.TaughtClasses.TaughtClass do
  @moduledoc """
  TaughtClasses schema module
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "taught_classes" do
    field(:comment, :string)
    belongs_to(:account, Backend.Accounts.Account, foreign_key: :taught_by_id)
    belongs_to(:class, Backend.Classes.Class)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(taught_class, attrs) do
    taught_class
    |> cast(attrs, [:comment, :taught_by_id, :class_id])
    |> validate_required([:taught_by_id, :class_id])
    |> foreign_key_constraint(:taught_by_id)
    |> foreign_key_constraint(:class_id)
  end
end
