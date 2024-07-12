defmodule Backend.SpecialitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Specialities` context.
  """

  @doc """
  Generate a unique speciality code.
  """
  def unique_speciality_code, do: "some code#{System.unique_integer([:positive])}"

  @doc """
  Generate a speciality.
  """
  def speciality_fixture(attrs \\ %{}) do
    {:ok, speciality} =
      attrs
      |> Enum.into(%{
        code: unique_speciality_code(),
        description: "some description",
        title: "some title"
      })
      |> Backend.Specialities.create_speciality()

    speciality
  end
end
