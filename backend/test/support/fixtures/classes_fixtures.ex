defmodule Backend.ClassesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Classes` context.
  """

  @doc """
  Generate a class.
  """
  def class_fixture(attrs \\ %{}) do
    {:ok, class} =
      attrs
      |> Enum.into(%{
        begin_date: ~U[2024-08-11 20:26:00Z],
        classroom: "some classroom"
      })
      |> Backend.Classes.create_class()

    class
  end
end
