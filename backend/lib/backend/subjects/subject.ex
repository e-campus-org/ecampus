defmodule Backend.Subjects.Subject do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:description, :title, :short_title, :prerequisites, :objectives],
    sortable: [:short_title, :title]
  }

  schema "subjects" do
    field(:description, :string)
    field(:title, :string)
    field(:short_title, :string)
    field(:prerequisites, :string)
    field(:objectives, :string)
    field(:required_texts, :string)
    has_many(:lessons, Backend.Lessons.Lesson)
    many_to_many(:groups, Backend.Groups.Group, join_through: "taught_subjects")

    many_to_many(:teachers, Backend.Accounts.Account,
      join_through: "taught_subjects",
      join_keys: [subject_id: :id, taught_by_id: :id]
    )

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(subject, attrs) do
    subject
    |> cast(attrs, [
      :title,
      :short_title,
      :description,
      :prerequisites,
      :objectives,
      :required_texts
    ])
    |> validate_required([:title, :short_title])
    |> unique_constraint(:short_title)
    |> unique_constraint(:title)
  end
end
