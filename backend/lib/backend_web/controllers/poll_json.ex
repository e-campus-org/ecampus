defmodule BackendWeb.PollJSON do
  alias Backend.Polls.PollQuestion
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
      questions: for(question <- poll.poll_questions, do: data_question(question)),
      inserted_at: poll.inserted_at,
      updated_at: poll.updated_at
    }
  end

  defp data_question(%PollQuestion{} = poll_question) do
    %{
      id: poll_question.id,
      title: poll_question.title,
      subtitle: poll_question.subtitle,
      poll_id: poll_question.poll_id,
      inserted_at: poll_question.inserted_at,
      updated_at: poll_question.updated_at
    }
  end
end
