defmodule BackendWeb.SubjectControllerTest do
  use BackendWeb.ConnCase

  import Backend.Auth.Guardian

  import Backend.GroupsFixtures

  import Backend.AccountsFixtures

  import Backend.SubjectsFixtures

  alias Backend.Subjects.Subject

  @create_attrs %{
    description: "some description",
    title: "some title",
    short_title: "some short_title",
    prerequisites: "some prerequisites",
    objectives: "some objectives",
    required_texts: "some required_texts"
  }
  @update_attrs %{
    description: "some updated description",
    title: "some updated title",
    short_title: "some updated short_title",
    prerequisites: "some updated prerequisites",
    objectives: "some updated objectives",
    required_texts: "some updated required_texts"
  }
  @invalid_attrs %{
    description: nil,
    title: nil,
    short_title: nil,
    prerequisites: nil,
    objectives: nil,
    required_texts: nil
  }

  @admin_account %{
    id: 1,
    first_name: "John",
    last_name: "Doe",
    email: "admin@ecampus.com",
    password: "qwerty",
    password_confirmation: "qwerty",
    roles: [:admin]
  }

  @teacher_account %{
    id: 1,
    first_name: "John",
    last_name: "Doe",
    email: "admin@ecampus.com",
    password: "qwerty",
    password_confirmation: "qwerty",
    roles: [:teacher]
  }

  setup %{conn: conn} do
    {:ok, _, token} = create_token(@teacher_account)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{token}")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all subjects", %{conn: conn} do
      conn = get(conn, ~p"/api/subjects")
      assert json_response(conn, 200)["list"] == []
    end
  end

  describe "create subject" do
    test "renders subject when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/subjects", subject: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, ~p"/api/subjects/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "objectives" => "some objectives",
               "prerequisites" => "some prerequisites",
               "required_texts" => "some required_texts",
               "short_title" => "some short_title",
               "title" => "some title"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/subjects", subject: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update subject" do
    setup [:create_subject]

    test "renders subject when data is valid", %{conn: conn, subject: %Subject{id: id} = subject} do
      conn = put(conn, ~p"/api/subjects/#{subject}", subject: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/api/subjects/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "objectives" => "some updated objectives",
               "prerequisites" => "some updated prerequisites",
               "required_texts" => "some updated required_texts",
               "short_title" => "some updated short_title",
               "title" => "some updated title"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, subject: subject} do
      conn = put(conn, ~p"/api/subjects/#{subject}", subject: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete subject" do
    setup [:create_subject]

    test "deletes chosen subject", %{conn: conn, subject: subject} do
      conn = delete(conn, ~p"/api/subjects/#{subject}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/subjects/#{subject}")
      end
    end
  end

  describe "link subject with teacher and group as admin" do
    setup [:create_subject, :create_account, :create_group]

    setup %{conn: conn} do
      {:ok, _, token} = create_token(@admin_account)

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{token}")

      {:ok, conn: conn}
    end

    test "renders subject when data is valid", %{
      conn: conn,
      account: account,
      group: group,
      subject: subject
    } do
      account_id = account.id

      conn =
        put(conn, ~p"/api/subjects/#{subject.id}/link", %{
          "taught_by_id" => account_id,
          "group_id" => group.id
        })

      assert %{} = json_response(conn, 200)
    end

    test "show error when data is invalid", %{
      conn: conn,
      account: account,
      group: group,
      subject: subject
    } do
      account_id = account.id

      conn =
        put(conn, ~p"/api/subjects/#{subject.id}/link", %{
          "taught_by_id" => account_id + 1,
          "group_id" => group.id + 1
        })

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "link subject with teacher and group as teacher" do
    setup [:create_subject, :create_account, :create_group]

    setup %{conn: conn} do
      {:ok, _, token} = create_token(@teacher_account)

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{token}")

      {:ok, conn: conn}
    end

    test "show 401", %{
      conn: conn,
      account: account,
      group: group,
      subject: subject
    } do
      account_id = account.id

      conn =
        put(conn, ~p"/api/subjects/#{subject.id}/link", %{
          "taught_by_id" => account_id,
          "group_id" => group.id
        })

      assert json_response(conn, 403) != %{}
    end
  end

  defp create_subject(_) do
    subject = subject_fixture()
    %{subject: subject}
  end

  defp create_group(_) do
    group = group_fixture()
    %{group: group}
  end

  defp create_account(_) do
    account = account_fixture(%{roles: [:teacher]})
    %{account: account}
  end
end
