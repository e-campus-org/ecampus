defmodule Backend.GroupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Groups` context.
  """

  @doc """
  Generate a unique group title.
  """
  def unique_group_title, do: "some title#{System.unique_integer([:positive])}"

  @doc """
  Generate a group.
  """
  def group_fixture(attrs \\ %{}) do
    {:ok, group} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: unique_group_title()
      })
      |> Backend.Groups.create_group()

    group
  end
end
