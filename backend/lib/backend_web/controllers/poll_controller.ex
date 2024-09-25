defmodule BackendWeb.PollController do
  use BackendWeb, :controller

  use PhoenixSwagger

  alias Backend.Polls
  alias Backend.Polls.Poll

  import Backend.Auth.Plugs

  action_fallback(BackendWeb.FallbackController)

  plug(:is_teacher)

  def index(conn, %{"page" => _page, "page_size" => _page_size} = params) do
    data = Polls.list_polls(params)
    render(conn, :index, data: data)
  end

  def index(conn, _params) do
    data = Polls.list_accounts(%{"page" => 1, "page_size" => 10})
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
end
