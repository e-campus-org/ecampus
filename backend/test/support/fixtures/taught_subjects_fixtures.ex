defmodule Backend.TaughtSubjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.TaughtSubjects` context.
  """

  @doc """
  Generate a taught_subject.
  """
  def taught_subject_fixture(attrs \\ %{}) do
    {:ok, taught_subject} =
      attrs
      |> Enum.into(%{

      })
      |> Backend.TaughtSubjects.create_taught_subject()

    taught_subject
  end
end
