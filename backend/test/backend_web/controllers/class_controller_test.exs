defmodule BackendWeb.ClassControllerTest do
  use BackendWeb.ConnCase

  import Backend.Auth.Guardian

  import Backend.AccountsFixtures

  import Backend.ClassesFixtures

  import Backend.LessonsFixtures

  import Backend.SubjectsFixtures

  import Backend.GroupsFixtures

  @create_attrs %{
    begin_date: ~U[2024-08-11 20:26:00Z],
    classroom: "some classroom",
    lesson_id: nil,
    group_id: nil
  }
  @update_attrs %{
    begin_date: ~U[2024-08-12 20:26:00Z],
    classroom: "some updated classroom",
    lesson_id: nil,
    group_id: nil
  }
  @invalid_attrs %{begin_date: nil, classroom: nil, lesson_id: nil, group_id: nil}

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
    test "lists all classes", %{conn: conn} do
      conn = get(conn, ~p"/api/classes")
      assert json_response(conn, 200)["list"] == []
    end
  end

  describe "create class" do
    setup [:create_group, :create_lesson]

    test "renders class when data is valid", %{
      conn: conn,
      lesson: %{id: lesson_id},
      group: %{id: group_id}
    } do
      conn =
        post(conn, ~p"/api/classes",
          class: %{@create_attrs | lesson_id: lesson_id, group_id: group_id}
        )

      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, ~p"/api/classes/#{id}")

      expected_begin_date = @create_attrs.begin_date
      expected_classroom = @create_attrs.classroom

      assert %{
               "id" => ^id,
               "begin_date" => ^expected_begin_date,
               "classroom" => ^expected_classroom,
               "lesson" => %{"id" => ^lesson_id},
               "group" => %{"id" => ^group_id}
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/classes", class: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update class" do
    setup [:create_class, :create_group, :create_lesson]

    test "renders class when data is valid", %{
      conn: conn,
      class: %{id: id},
      lesson: %{id: lesson_id},
      group: %{id: group_id}
    } do
      conn =
        put(conn, ~p"/api/classes/#{class}",
          class: %{@update_attrs | lesson_id: lesson_id, group_id: group_id}
        )

      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/api/classes/#{id}")

      expected_begin_date = @create_attrs.begin_date
      expected_classroom = @create_attrs.classroom

      assert %{
               "id" => ^id,
               "begin_date" => ^expected_begin_date,
               "classroom" => ^expected_classroom,
               "lesson" => %{"id" => ^lesson_id},
               "group" => %{"id" => ^group_id}
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, class: class} do
      conn = put(conn, ~p"/api/classes/#{class}", class: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete class" do
    setup [:create_class]

    test "deletes chosen class", %{conn: conn, class: class} do
      conn = delete(conn, ~p"/api/classes/#{class}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/classes/#{class}")
      end
    end
  end

  describe "link class with teacher and group" do
    setup [:create_class, :create_account, :create_group]

    test "renders class when data is valid", %{
      conn: conn,
      class: %{id: id},
      account: %{id: account_id} = account,
      group: %{id: group_id}
    } do
      conn =
        put(conn, ~p"/api/classes/#{id}/link", %{
          "taught_by_id" => account_id,
          "group_id" => group_id
        })

      assert %{teachers: teachers, id: id} = json_response(conn, 200)
      assert id == class.id
      assert Enum.at(teachers, 0) == account
    end
  end

  defp create_account(_) do
    account = account_fixture(%{roles: [:teacher]})
    %{account: account}
  end

  defp create_group(_) do
    group = group_fixture()
    %{group: group}
  end

  defp create_lesson(_) do
    subject = subject_fixture()
    lesson = lesson_fixture(%{subject_id: subject.id})
    %{lesson: lesson}
  end

  defp create_class(_) do
    subject = subject_fixture()
    lesson = lesson_fixture(%{subject_id: subject.id})
    group = group_fixture()
    class = class_fixture(%{lesson_id: lesson.id, group_id: group.id})
    %{class: class}
  end
end
