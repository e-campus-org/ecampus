defmodule Backend.Auth.Plugs do
  @moduledoc """
  Plugs module for authentication purposes
  """

  import Plug.Conn

  def admin?(conn, _opts), do: has_role("admin", conn)

  def teacher?(conn, _opts), do: has_role("teacher", conn)

  def student?(conn, _opts), do: has_role("student", conn)

  defp has_role(role, conn) do
    %{private: %{:guardian_default_resource => %{"account" => %{"roles" => roles}}}} = conn

    if is_list(roles) and Enum.member?(roles, role) do
      conn
    else
      body = Jason.encode!(%{error: "You don't have permissions to access this resource"})

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(403, body)
      |> halt()
    end
  end
end
