defmodule BackendWeb.AuthController do
  use BackendWeb, :controller

  alias Backend.Auth.Guardian

  action_fallback(BackendWeb.FallbackController)

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:ok, _account, token} ->
        conn
        |> put_status(:ok)
        |> render(:token, token: token)

      {:error, :unauthorized} ->
        {:error, :unauthorized}
    end
  end
end
