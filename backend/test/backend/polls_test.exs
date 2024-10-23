defmodule Backend.PollsTest do
  use Backend.DataCase

  alias Backend.Polls

  describe "polls" do
    alias Backend.Polls.Poll

    import Backend.PollsFixtures

    @invalid_attrs %{description: nil, title: nil}

    test "list_polls/0 returns all polls" do
      poll = poll_fixture()
      assert Polls.list_polls() == [poll]
    end

    test "get_poll!/1 returns the poll with given id" do
      poll = poll_fixture()
      assert Polls.get_poll!(poll.id) == poll
    end

    test "create_poll/1 with valid data creates a poll" do
      valid_attrs = %{description: "some description", title: "some title"}

      assert {:ok, %Poll{} = poll} = Polls.create_poll(valid_attrs)
      assert poll.description == "some description"
      assert poll.title == "some title"
    end

    test "create_poll/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Polls.create_poll(@invalid_attrs)
    end

    test "update_poll/2 with valid data updates the poll" do
      poll = poll_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title"}

      assert {:ok, %Poll{} = poll} = Polls.update_poll(poll, update_attrs)
      assert poll.description == "some updated description"
      assert poll.title == "some updated title"
    end

    test "update_poll/2 with invalid data returns error changeset" do
      poll = poll_fixture()
      assert {:error, %Ecto.Changeset{}} = Polls.update_poll(poll, @invalid_attrs)
      assert poll == Polls.get_poll!(poll.id)
    end

    test "delete_poll/1 deletes the poll" do
      poll = poll_fixture()
      assert {:ok, %Poll{}} = Polls.delete_poll(poll)
      assert_raise Ecto.NoResultsError, fn -> Polls.get_poll!(poll.id) end
    end

    test "change_poll/1 returns a poll changeset" do
      poll = poll_fixture()
      assert %Ecto.Changeset{} = Polls.change_poll(poll)
    end
  end

  describe "polls" do
    alias Backend.Polls.PollQuestion

    import Backend.PollsFixtures

    @invalid_attrs %{type: nil, title: nil, subtitle: nil}

    test "list_polls/0 returns all polls" do
      poll_question = poll_question_fixture()
      assert Polls.list_polls() == [poll_question]
    end

    test "get_poll_question!/1 returns the poll_question with given id" do
      poll_question = poll_question_fixture()
      assert Polls.get_poll_question!(poll_question.id) == poll_question
    end

    test "create_poll_question/1 with valid data creates a poll_question" do
      valid_attrs = %{type: :single, title: "some title", subtitle: "some subtitle"}

      assert {:ok, %PollQuestion{} = poll_question} = Polls.create_poll_question(valid_attrs)
      assert poll_question.type == :single
      assert poll_question.title == "some title"
      assert poll_question.subtitle == "some subtitle"
    end

    test "create_poll_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Polls.create_poll_question(@invalid_attrs)
    end

    test "update_poll_question/2 with valid data updates the poll_question" do
      poll_question = poll_question_fixture()
      update_attrs = %{type: :multiple, title: "some updated title", subtitle: "some updated subtitle"}

      assert {:ok, %PollQuestion{} = poll_question} = Polls.update_poll_question(poll_question, update_attrs)
      assert poll_question.type == :multiple
      assert poll_question.title == "some updated title"
      assert poll_question.subtitle == "some updated subtitle"
    end

    test "update_poll_question/2 with invalid data returns error changeset" do
      poll_question = poll_question_fixture()
      assert {:error, %Ecto.Changeset{}} = Polls.update_poll_question(poll_question, @invalid_attrs)
      assert poll_question == Polls.get_poll_question!(poll_question.id)
    end

    test "delete_poll_question/1 deletes the poll_question" do
      poll_question = poll_question_fixture()
      assert {:ok, %PollQuestion{}} = Polls.delete_poll_question(poll_question)
      assert_raise Ecto.NoResultsError, fn -> Polls.get_poll_question!(poll_question.id) end
    end

    test "change_poll_question/1 returns a poll_question changeset" do
      poll_question = poll_question_fixture()
      assert %Ecto.Changeset{} = Polls.change_poll_question(poll_question)
    end
  end
end
