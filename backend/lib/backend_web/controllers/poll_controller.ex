defmodule BackendWeb.PollController do
  use BackendWeb, :controller

  alias Backend.Polls.PollResult
  alias Backend.Polls.PollQuestion
  alias Backend.Polls
  alias Backend.Polls.Poll

  import Backend.Auth.Plugs

  action_fallback(BackendWeb.FallbackController)

  plug(:is_teacher when action not in [:answer_poll_question])
  plug(:is_student when action in [:answer_poll_question])

  def index(conn, %{"page" => _page, "page_size" => _page_size} = params) do
    data = Polls.list_polls(params)
    render(conn, :index, data: data)
  end

  def index(conn, _params) do
    data = Polls.list_polls(%{"page" => 1, "page_size" => 10})
    render(conn, :index, data: data)
  end

  def create(conn, %{"poll" => poll_params}) do
    with {:ok, %Poll{} = poll} <- Polls.create_poll(poll_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/polls/#{poll}")
      |> render(:show, poll: poll)
    end
  end

  def show(conn, %{"id" => id}) do
    poll = Polls.get_poll!(id)
    render(conn, :show, poll: poll)
  end

  def update(conn, %{"id" => id, "poll" => poll_params}) do
    poll = Polls.get_poll!(id)

    with {:ok, %Poll{} = poll} <- Polls.update_poll(poll, poll_params) do
      render(conn, :show, poll: poll)
    end
  end

  def delete(conn, %{"id" => id}) do
    poll = Polls.get_poll!(id)

    with {:ok, %Poll{}} <- Polls.delete_poll(poll) do
      send_resp(conn, :no_content, "")
    end
  end

  def create_question(conn, %{"id" => id, "question" => question_params}) do
    with {:ok, %PollQuestion{} = question} <-
           question_params
           |> Map.put("poll_id", String.to_integer(id))
           |> Polls.create_poll_question() do
      conn
      |> put_status(:created)
      |> render(:show_question, question: question)
    end
  end

  def update_question(conn, %{
        "id" => id,
        "question_id" => question_id,
        "question" => question_params
      }) do
    question_params = Map.put(question_params, "poll_id", String.to_integer(id))

    with {:ok, %PollQuestion{} = question} <-
           Polls.get_poll_question!(question_id)
           |> Polls.update_poll_question(question_params) do
      render(conn, :show_question, question: question)
    end
  end

  def delete_question(conn, %{"id" => id, "question_id" => question_id}) do
    with {:ok, %PollQuestion{}} <-
           Polls.delete_poll_question(%PollQuestion{
             poll_id: String.to_integer(id),
             id: String.to_integer(question_id)
           }) do
      send_resp(conn, :no_content, "")
    end
  end

  def answer_question(conn, %{"id" => _, "question_id" => question_id, "answer" => answer_params}) do
    %{private: %{:guardian_default_resource => %{"account" => %{"id" => account_id}}}} = conn

    case answer_params
         |> Map.put("poll_questions_id", String.to_integer(question_id))
         |> Map.put("accounts_id", account_id)
         |> Polls.create_poll_result() do
      {:ok, _} -> send_resp(conn, :created, "")
      {:already_exists} -> send_resp(conn, :conflict, "")
    end
  end
end
