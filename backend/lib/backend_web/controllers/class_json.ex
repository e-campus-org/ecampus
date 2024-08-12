defmodule BackendWeb.ClassJSON do
  alias Backend.Classes.Class

  @doc """
  Renders a list of classes.
  """
  def index(%{data: {:ok, %{list: list, pagination: pagination}}}) do
    %{list: for(class <- list, do: data(class)), pagination: pagination}
  end

  def index(%{data: {:error, _paylaod}}) do
    %{error: "Wrong params"}
  end

  @doc """
  Renders a single class.
  """
  def show(%{class: class}) do
    %{data: data(class)}
  end

  defp data(%Class{} = class) do
    %{
      id: class.id,
      begin_date: class.begin_date,
      classroom: class.classroom,
      lesson_id: class.lesson_id,
      group_id: class.group_id,
      inserted_at: class.inserted_at,
      updated_at: class.updated_at
    }
  end
end
