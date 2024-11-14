defmodule BackendWeb.QuizControllerTest do
  use BackendWeb.ConnCase

  import Backend.QuizzesFixtures

  alias Backend.Quizzes.Quiz

  @create_attrs %{
    description: "some description",
    title: "some title"
  }
  @update_attrs %{
    description: "some updated description",
    title: "some updated title"
  }
  @invalid_attrs %{description: nil, title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    # test "lists all quizzes", %{conn: conn} do
    #   conn = get(conn, ~p"/api/quizzes")
    #   assert json_response(conn, 200)["data"] == []
    # end
  end

  describe "create quiz" do
    # test "renders quiz when data is valid", %{conn: conn} do
    #   conn = post(conn, ~p"/api/quizzes", quiz: @create_attrs)
    #   assert %{"id" => id} = json_response(conn, 201)["data"]

    #   conn = get(conn, ~p"/api/quizzes/#{id}")

    #   assert %{
    #            "id" => ^id,
    #            "description" => "some description",
    #            "title" => "some title"
    #          } = json_response(conn, 200)["data"]
    # end

    # test "renders errors when data is invalid", %{conn: conn} do
    #   conn = post(conn, ~p"/api/quizzes", quiz: @invalid_attrs)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "update quiz" do
    # setup [:create_quiz]

    # test "renders quiz when data is valid", %{conn: conn, quiz: %Quiz{id: id} = quiz} do
    #   conn = put(conn, ~p"/api/quizzes/#{quiz}", quiz: @update_attrs)
    #   assert %{"id" => ^id} = json_response(conn, 200)["data"]

    #   conn = get(conn, ~p"/api/quizzes/#{id}")

    #   assert %{
    #            "id" => ^id,
    #            "description" => "some updated description",
    #            "title" => "some updated title"
    #          } = json_response(conn, 200)["data"]
    # end

    # test "renders errors when data is invalid", %{conn: conn, quiz: quiz} do
    #   conn = put(conn, ~p"/api/quizzes/#{quiz}", quiz: @invalid_attrs)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "delete quiz" do
    # setup [:create_quiz]

    # test "deletes chosen quiz", %{conn: conn, quiz: quiz} do
    #   conn = delete(conn, ~p"/api/quizzes/#{quiz}")
    #   assert response(conn, 204)

    #   assert_error_sent 404, fn ->
    #     get(conn, ~p"/api/quizzes/#{quiz}")
    #   end
    # end
  end

  defp create_quiz(_) do
    quiz = quiz_fixture()
    %{quiz: quiz}
  end
end
