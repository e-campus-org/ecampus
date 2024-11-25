defmodule Backend.Subjects.TaughtSubject do
  use Ecto.Schema
  import Ecto.Changeset

  schema "taught_subjects" do
    belongs_to(:account, Backend.Accounts.Account, foreign_key: :taught_by_id)
    belongs_to(:group, Backend.Groups.Group)
    belongs_to(:subject, Backend.Subjects.Subject)

    field(:comment, :string)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(taught_subject, attrs) do
    taught_subject
    |> cast(attrs, [:taught_by_id, :group_id, :subject_id, :comment])
    |> validate_required([:taught_by_id, :group_id, :subject_id])
    |> foreign_key_constraint(:taught_by_id)
    |> foreign_key_constraint(:group_id)
    |> foreign_key_constraint(:subject_id)
  end
end
