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

  @doc """
  Generate a poll_question.
  """
  def poll_question_fixture(attrs \\ %{}) do
    {:ok, poll_question} =
      attrs
      |> Enum.into(%{
        subtitle: "some subtitle",
        title: "some title",
        type: :single
      })
      |> Backend.Polls.create_poll_question()

    poll_question
  end

  @doc """
  Generate a poll_answer.
  """
  def poll_answer_fixture(attrs \\ %{}) do
    {:ok, poll_answer} =
      attrs
      |> Enum.into(%{
        subtitle: "some subtitle",
        title: "some title"
      })
      |> Backend.Polls.create_poll_answer()

    poll_answer
  end

  @doc """
  Generate a poll_result.
  """
  def poll_result_fixture(attrs \\ %{}) do
    {:ok, poll_result} =
      attrs
      |> Enum.into(%{
        open_question_text: "some open_question_text"
      })
      |> Backend.Polls.create_poll_result()

    poll_result
  end
end
