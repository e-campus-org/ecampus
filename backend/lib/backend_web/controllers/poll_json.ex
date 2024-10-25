defmodule BackendWeb.PollJSON do
  alias Backend.Polls.Poll

  @doc """
  Renders a list of polls.
  """
  def index(%{data: {:ok, %{list: list, pagination: pagination}}}) do
    %{list: for(poll <- list, do: data(poll)), pagination: pagination}
  end

  def index(%{data: {:error, _paylaod}}) do
    %{error: "Wrong params"}
  end

  @doc """
  Renders a single poll.
  """
  def show(%{poll: poll}) do
    %{data: data(poll)}
  end

  defp data(%Poll{} = poll) do
    %{
      id: poll.id,
      title: poll.title,
      description: poll.description,
      inserted_at: poll.inserted_at,
      updated_at: poll.updated_at
    }
  end
end
