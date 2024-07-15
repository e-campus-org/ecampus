defmodule Backend.Guardian do
  use Guardian, otp_app: :backend

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Backend.Accounts.get_account!(id)
    {:ok, resource}
  end
end
