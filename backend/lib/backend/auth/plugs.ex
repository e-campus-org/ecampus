defmodule Backend.Auth.Plugs do
  import Plug.Conn

  def is_admin(conn, _opts) do
    %{private: %{:guardian_default_resource => %{"account" => %{"roles" => roles}}}} = conn

    if is_list(roles) and Enum.member?(roles, "admin") do
      conn
    else
      body = Jason.encode!(%{error: "You don't have permissions to access this resource"})

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(403, body)
      |> halt()
    end
  end

  def is_teacher(conn, _opts) do
    %{private: %{:guardian_default_resource => %{"account" => %{"roles" => roles}}}} = conn

    if is_list(roles) and (Enum.member?(roles, "teacher") or Enum.member?(roles, "admin")) do
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
