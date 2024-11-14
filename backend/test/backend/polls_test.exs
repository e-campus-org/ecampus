defmodule Backend.PollsTest do
  use Backend.DataCase

  alias Backend.Polls

  # describe "polls" do
  # alias Backend.Polls.Poll

  # import Backend.PollsFixtures

  # @invalid_attrs %{description: nil, title: nil}

  # test "list_polls/0 returns all polls" do
  #   poll = poll_fixture()
  #   assert Polls.list_polls() == [poll]
  # end

  # test "get_poll!/1 returns the poll with given id" do
  #   poll = poll_fixture()
  #   assert Polls.get_poll!(poll.id) == poll
  # end

  # test "create_poll/1 with valid data creates a poll" do
  #   valid_attrs = %{description: "some description", title: "some title"}

  #   assert {:ok, %Poll{} = poll} = Polls.create_poll(valid_attrs)
  #   assert poll.description == "some description"
  #   assert poll.title == "some title"
  # end

  # test "create_poll/1 with invalid data returns error changeset" do
  #   assert {:error, %Ecto.Changeset{}} = Polls.create_poll(@invalid_attrs)
  # end

  # test "update_poll/2 with valid data updates the poll" do
  #   poll = poll_fixture()
  #   update_attrs = %{description: "some updated description", title: "some updated title"}

  #   assert {:ok, %Poll{} = poll} = Polls.update_poll(poll, update_attrs)
  #   assert poll.description == "some updated description"
  #   assert poll.title == "some updated title"
  # end

  # test "update_poll/2 with invalid data returns error changeset" do
  #   poll = poll_fixture()
  #   assert {:error, %Ecto.Changeset{}} = Polls.update_poll(poll, @invalid_attrs)
  #   assert poll == Polls.get_poll!(poll.id)
  # end

  # test "delete_poll/1 deletes the poll" do
  #   poll = poll_fixture()
  #   assert {:ok, %Poll{}} = Polls.delete_poll(poll)
  #   assert_raise Ecto.NoResultsError, fn -> Polls.get_poll!(poll.id) end
  # end

  # test "change_poll/1 returns a poll changeset" do
  #   poll = poll_fixture()
  #   assert %Ecto.Changeset{} = Polls.change_poll(poll)
  # end
  # end

  describe "polls" do
    # alias Backend.Polls.PollQuestion

    # import Backend.PollsFixtures

    # @invalid_attrs %{type: nil, title: nil, subtitle: nil}

    # test "list_polls/0 returns all polls" do
    #   poll_question = poll_question_fixture()
    #   assert Polls.list_polls() == [poll_question]
    # end

    # test "get_poll_question!/1 returns the poll_question with given id" do
    #   poll_question = poll_question_fixture()
    #   assert Polls.get_poll_question!(poll_question.id) == poll_question
    # end

    # test "create_poll_question/1 with valid data creates a poll_question" do
    #   valid_attrs = %{type: :single, title: "some title", subtitle: "some subtitle"}

    #   assert {:ok, %PollQuestion{} = poll_question} = Polls.create_poll_question(valid_attrs)
    #   assert poll_question.type == :single
    #   assert poll_question.title == "some title"
    #   assert poll_question.subtitle == "some subtitle"
    # end

    # test "create_poll_question/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Polls.create_poll_question(@invalid_attrs)
    # end

    # test "update_poll_question/2 with valid data updates the poll_question" do
    #   poll_question = poll_question_fixture()
    #   update_attrs = %{type: :multiple, title: "some updated title", subtitle: "some updated subtitle"}

    #   assert {:ok, %PollQuestion{} = poll_question} = Polls.update_poll_question(poll_question, update_attrs)
    #   assert poll_question.type == :multiple
    #   assert poll_question.title == "some updated title"
    #   assert poll_question.subtitle == "some updated subtitle"
    # end

    # test "update_poll_question/2 with invalid data returns error changeset" do
    #   poll_question = poll_question_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Polls.update_poll_question(poll_question, @invalid_attrs)
    #   assert poll_question == Polls.get_poll_question!(poll_question.id)
    # end

    # test "delete_poll_question/1 deletes the poll_question" do
    #   poll_question = poll_question_fixture()
    #   assert {:ok, %PollQuestion{}} = Polls.delete_poll_question(poll_question)
    #   assert_raise Ecto.NoResultsError, fn -> Polls.get_poll_question!(poll_question.id) end
    # end

    # test "change_poll_question/1 returns a poll_question changeset" do
    #   poll_question = poll_question_fixture()
    #   assert %Ecto.Changeset{} = Polls.change_poll_question(poll_question)
    # end
  end

  describe "poll_answers" do
    # alias Backend.Polls.PollAnswer

    # import Backend.PollsFixtures

    # @invalid_attrs %{title: nil, subtitle: nil}

    # test "list_poll_answers/0 returns all poll_answers" do
    #   poll_answer = poll_answer_fixture()
    #   assert Polls.list_poll_answers() == [poll_answer]
    # end

    # test "get_poll_answer!/1 returns the poll_answer with given id" do
    #   poll_answer = poll_answer_fixture()
    #   assert Polls.get_poll_answer!(poll_answer.id) == poll_answer
    # end

    # test "create_poll_answer/1 with valid data creates a poll_answer" do
    #   valid_attrs = %{title: "some title", subtitle: "some subtitle"}

    #   assert {:ok, %PollAnswer{} = poll_answer} = Polls.create_poll_answer(valid_attrs)
    #   assert poll_answer.title == "some title"
    #   assert poll_answer.subtitle == "some subtitle"
    # end

    # test "create_poll_answer/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Polls.create_poll_answer(@invalid_attrs)
    # end

    # test "update_poll_answer/2 with valid data updates the poll_answer" do
    #   poll_answer = poll_answer_fixture()
    #   update_attrs = %{title: "some updated title", subtitle: "some updated subtitle"}

    #   assert {:ok, %PollAnswer{} = poll_answer} = Polls.update_poll_answer(poll_answer, update_attrs)
    #   assert poll_answer.title == "some updated title"
    #   assert poll_answer.subtitle == "some updated subtitle"
    # end

    # test "update_poll_answer/2 with invalid data returns error changeset" do
    #   poll_answer = poll_answer_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Polls.update_poll_answer(poll_answer, @invalid_attrs)
    #   assert poll_answer == Polls.get_poll_answer!(poll_answer.id)
    # end

    # test "delete_poll_answer/1 deletes the poll_answer" do
    #   poll_answer = poll_answer_fixture()
    #   assert {:ok, %PollAnswer{}} = Polls.delete_poll_answer(poll_answer)
    #   assert_raise Ecto.NoResultsError, fn -> Polls.get_poll_answer!(poll_answer.id) end
    # end

    # test "change_poll_answer/1 returns a poll_answer changeset" do
    #   poll_answer = poll_answer_fixture()
    #   assert %Ecto.Changeset{} = Polls.change_poll_answer(poll_answer)
    # end
  end

  describe "poll_results" do
    # alias Backend.Polls.PollResult

    # import Backend.PollsFixtures

    # @invalid_attrs %{open_question_text: nil}

    # test "list_poll_results/0 returns all poll_results" do
    #   poll_result = poll_result_fixture()
    #   assert Polls.list_poll_results() == [poll_result]
    # end

    # test "get_poll_result!/1 returns the poll_result with given id" do
    #   poll_result = poll_result_fixture()
    #   assert Polls.get_poll_result!(poll_result.id) == poll_result
    # end

    # test "create_poll_result/1 with valid data creates a poll_result" do
    #   valid_attrs = %{open_question_text: "some open_question_text"}

    #   assert {:ok, %PollResult{} = poll_result} = Polls.create_poll_result(valid_attrs)
    #   assert poll_result.open_question_text == "some open_question_text"
    # end

    # test "create_poll_result/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Polls.create_poll_result(@invalid_attrs)
    # end

    # test "update_poll_result/2 with valid data updates the poll_result" do
    #   poll_result = poll_result_fixture()
    #   update_attrs = %{open_question_text: "some updated open_question_text"}

    #   assert {:ok, %PollResult{} = poll_result} = Polls.update_poll_result(poll_result, update_attrs)
    #   assert poll_result.open_question_text == "some updated open_question_text"
    # end

    # test "update_poll_result/2 with invalid data returns error changeset" do
    #   poll_result = poll_result_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Polls.update_poll_result(poll_result, @invalid_attrs)
    #   assert poll_result == Polls.get_poll_result!(poll_result.id)
    # end

    # test "delete_poll_result/1 deletes the poll_result" do
    #   poll_result = poll_result_fixture()
    #   assert {:ok, %PollResult{}} = Polls.delete_poll_result(poll_result)
    #   assert_raise Ecto.NoResultsError, fn -> Polls.get_poll_result!(poll_result.id) end
    # end

    # test "change_poll_result/1 returns a poll_result changeset" do
    #   poll_result = poll_result_fixture()
    #   assert %Ecto.Changeset{} = Polls.change_poll_result(poll_result)
    # end
  end
end
