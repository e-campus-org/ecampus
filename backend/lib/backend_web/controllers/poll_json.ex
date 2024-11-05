defmodule BackendWeb.PollJSON do
  alias Backend.Polls.PollQuestion
  alias Backend.Polls.PollAnswer
  alias Backend.Polls.Poll

  @doc """
  Renders a list of polls.
  """
  def index(%{data: {:ok, %{list: list, pagination: pagination}}}) do
    %{list: for(poll <- list, do: short_data(poll)), pagination: pagination}
  end

  def index(%{data: {:error, _payload}}) do
    %{error: "Wrong params"}
  end

  @doc """
  Renders a single poll.
  """
  def show(%{poll: poll}), do: data(poll)

  def show_question(%{question: question}), do: data_question(question)

  defp short_data(%Poll{} = poll) do
    %{
      id: poll.id,
      title: poll.title,
      description: poll.description,
      questions_count: length(poll.poll_questions),
      inserted_at: poll.inserted_at,
      updated_at: poll.updated_at
    }
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
      type: poll_question.type,
      poll_id: poll_question.poll_id,
      answers: for(answer <- poll_question.poll_answers, do: data_answer(answer)),
      inserted_at: poll_question.inserted_at,
      updated_at: poll_question.updated_at
    }
  end

  defp data_answer(%PollAnswer{} = poll_answer) do
    %{
      id: poll_answer.id,
      title: poll_answer.title,
      subtitle: poll_answer.subtitle,
      question_id: poll_answer.poll_question_id,
      inserted_at: poll_answer.inserted_at,
      updated_at: poll_answer.updated_at
    }
  end
end
