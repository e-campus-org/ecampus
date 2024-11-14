defmodule BackendWeb.SubjectControllerTest do
  use BackendWeb.ConnCase

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

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    # test "lists all subjects", %{conn: conn} do
    #   conn = get(conn, ~p"/api/subjects")
    #   assert json_response(conn, 200)["data"] == []
    # end
  end

  describe "create subject" do
    # test "renders subject when data is valid", %{conn: conn} do
    #   conn = post(conn, ~p"/api/subjects", subject: @create_attrs)
    #   assert %{"id" => id} = json_response(conn, 201)["data"]

    #   conn = get(conn, ~p"/api/subjects/#{id}")

    #   assert %{
    #            "id" => ^id,
    #            "description" => "some description",
    #            "objectives" => "some objectives",
    #            "prerequisites" => "some prerequisites",
    #            "required_texts" => "some required_texts",
    #            "short_title" => "some short_title",
    #            "title" => "some title"
    #          } = json_response(conn, 200)["data"]
    # end

    # test "renders errors when data is invalid", %{conn: conn} do
    #   conn = post(conn, ~p"/api/subjects", subject: @invalid_attrs)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "update subject" do
    # setup [:create_subject]

    # test "renders subject when data is valid", %{conn: conn, subject: %Subject{id: id} = subject} do
    #   conn = put(conn, ~p"/api/subjects/#{subject}", subject: @update_attrs)
    #   assert %{"id" => ^id} = json_response(conn, 200)["data"]

    #   conn = get(conn, ~p"/api/subjects/#{id}")

    #   assert %{
    #            "id" => ^id,
    #            "description" => "some updated description",
    #            "objectives" => "some updated objectives",
    #            "prerequisites" => "some updated prerequisites",
    #            "required_texts" => "some updated required_texts",
    #            "short_title" => "some updated short_title",
    #            "title" => "some updated title"
    #          } = json_response(conn, 200)["data"]
    # end

    # test "renders errors when data is invalid", %{conn: conn, subject: subject} do
    #   conn = put(conn, ~p"/api/subjects/#{subject}", subject: @invalid_attrs)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "delete subject" do
    # setup [:create_subject]

    # test "deletes chosen subject", %{conn: conn, subject: subject} do
    #   conn = delete(conn, ~p"/api/subjects/#{subject}")
    #   assert response(conn, 204)

    #   assert_error_sent 404, fn ->
    #     get(conn, ~p"/api/subjects/#{subject}")
    #   end
    # end
  end

  defp create_subject(_) do
    subject = subject_fixture()
    %{subject: subject}
  end
end
