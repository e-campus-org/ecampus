defmodule Backend.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field(:email, :string)
    field(:last_name, :string)
    field(:first_name, :string)
    field(:password_hash, :string)
    belongs_to(:group, Backend.Groups.Group)
    timestamps(type: :utc_datetime)

    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
  end

  @doc false
  def changeset(account, attrs) do
    attrs |> IO.inspect()

    account
    |> cast(attrs, [:email, :last_name, :first_name, :group_id, :password, :password_confirmation])
    |> validate_required([:email, :last_name, :first_name, :password, :password_confirmation])
    |> unique_constraint(:email)
    |> foreign_key_constraint(:group_id)
    |> validate_format(:email, ~r/^([a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$/)
    |> validate_length(:password, min: 6)
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
