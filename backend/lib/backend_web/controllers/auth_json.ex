defmodule BackendWeb.AuthJSON do
  @doc """
  Renders a jwt token object.
  """
  def token(%{token: token}) do
    %{access_token: token}
  end
end
