defmodule BackendWeb.SubjectController do
  use BackendWeb, :controller

  alias Backend.Subjects.TaughtSubject
  alias Backend.Subjects
  alias Backend.Subjects.Subject

  import Backend.Auth.Plugs

  action_fallback(BackendWeb.FallbackController)

  plug(:is_teacher when action in [:create, :update, :delete])
  plug(:is_admin when action in [:link_subject_with_teacher_and_group])

  def index(conn, %{"page" => _page, "page_size" => _page_size} = params) do
    data = Subjects.list_subjects(params)
    render(conn, :index, data: data)
  end

  def index(conn, _params) do
    data = Subjects.list_subjects(%{"page" => 1, "page_size" => 10})
    render(conn, :index, data: data)
  end

  def create(conn, %{"subject" => subject_params}) do
    with {:ok, %Subject{} = subject} <- Subjects.create_subject(subject_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/subjects/#{subject}")
      |> render(:show, subject: subject)
    end
  end

  def show(conn, %{"id" => id}) do
    subject = Subjects.get_subject!(id)
    render(conn, :show, subject: subject)
  end

  def update(conn, %{"id" => id, "subject" => subject_params}) do
    subject = Subjects.get_subject!(id)

    with {:ok, %Subject{} = subject} <- Subjects.update_subject(subject, subject_params) do
      render(conn, :show, subject: subject)
    end
  end

  def delete(conn, %{"id" => id}) do
    subject = Subjects.get_subject!(id)

    with {:ok, %Subject{}} <- Subjects.delete_subject(subject) do
      send_resp(conn, :no_content, "")
    end
  end

  def link_subject_with_teacher_and_group(
        conn,
        %{
          "subject_id" => _subject_id,
          "taught_by_id" => _account_id,
          "group_id" => _group_id
        } = params
      ) do
    with {:ok, %TaughtSubject{} = taught_subject} <-
           Subjects.link_subject_with_teacher_and_group(params) do
      render(conn, :show, subject: taught_subject.subject)
    end
  end
end
