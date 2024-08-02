defmodule Backend.SubjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Subjects` context.
  """

  @doc """
  Generate a unique subject short_title.
  """
  def unique_subject_short_title, do: "some short_title#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique subject title.
  """
  def unique_subject_title, do: "some title#{System.unique_integer([:positive])}"

  @doc """
  Generate a subject.
  """
  def subject_fixture(attrs \\ %{}) do
    {:ok, subject} =
      attrs
      |> Enum.into(%{
        description: "some description",
        objectives: "some objectives",
        prerequisites: "some prerequisites",
        required_texts: "some required_texts",
        short_title: unique_subject_short_title(),
        title: unique_subject_title()
      })
      |> Backend.Subjects.create_subject()

    subject
  end
end
