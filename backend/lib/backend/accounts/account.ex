defmodule Backend.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:email, :last_name, :first_name, :group_id],
    sortable: [:email, :last_name, :first_name]
  }

  @roles [:student, :teacher, :admin]

  schema "accounts" do
    field(:email, :string)
    field(:last_name, :string)
    field(:first_name, :string)
    field(:password_hash, :string)
    field(:roles, {:array, Ecto.Enum}, values: @roles)
    belongs_to(:group, Backend.Groups.Group)

    many_to_many(:subjects, Backend.Subjects.Subject,
      join_through: "taught_subjects",
      join_keys: [taught_by_id: :id, subject_id: :id]
    )

    many_to_many(:taught_groups, Backend.Groups.Group, join_through: "taught_subjects")

    many_to_many(:answered_questions, Backend.Questions.Question,
      join_through: "answered_questions",
      join_keys: [student_id: :id, question_id: :id]
    )

    timestamps(type: :utc_datetime)

    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [
      :email,
      :last_name,
      :first_name,
      :group_id,
      :password,
      :password_confirmation,
      :roles
    ])
    |> validate_required([
      :email,
      :last_name,
      :first_name,
      :password,
      :password_confirmation,
      :roles
    ])
    |> unique_constraint(:email)
    |> foreign_key_constraint(:group_id)
    |> validate_format(:email, ~r/^([a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$/)
    |> validate_length(:password, min: 6)
    |> validate_length(:roles, min: 1, max: 3)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end
