defmodule Backend.Auth.Guardian do
  use Guardian, otp_app: :backend

  alias Backend.Accounts

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _), do: {:error, :no_id_provided}

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_account!(id) do
      nil -> {:error, :not_found}
      resource -> {:ok, resource}
    end
  end

  def resource_from_claims(_), do: {:error, :no_id_provided}

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

  defp create_token(account) do
    {:ok, token, _claims} = encode_and_sign(account)
    {:ok, account, token}
  end
end
