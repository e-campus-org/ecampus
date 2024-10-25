defmodule Backend.PollsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Polls` context.
  """

  @doc """
  Generate a poll.
  """
  def poll_fixture(attrs \\ %{}) do
    {:ok, poll} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> Backend.Polls.create_poll()

    poll
  end
end
