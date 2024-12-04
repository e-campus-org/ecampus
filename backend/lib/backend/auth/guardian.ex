defmodule Backend.Auth.Guardian do
  @moduledoc """
  JWT management module
  """

  use Guardian, otp_app: :backend

  alias Backend.Accounts

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _), do: {:error, :not_provided}

  def resource_from_claims(claims), do: {:ok, claims}

  def authenticate(email, password) do
    case Accounts.get_account_by_email(email) do
      {:error, _} ->
        {:error, :unauthorized}

      {:ok, account} ->
        case validate_password(password, account.password_hash) do
          true -> create_token(account)
          false -> {:error, :unauthorized}
        end
    end
  end

  defp validate_password(password, password_hash) do
    Bcrypt.verify_pass(password, password_hash)
  end

  def create_token(account) do
    user_claims = %{"id" => account.id, "email" => account.email, "roles" => account.roles}

    {:ok, token, _claims} =
      encode_and_sign(account, %{"account" => user_claims}, token_type: :access)

    {:ok, account, token}
  end
end
