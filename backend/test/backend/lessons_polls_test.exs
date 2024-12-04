defmodule Backend.LessonsPollsTest do
  use Backend.DataCase

  alias Backend.LessonsPolls

  describe "lessons_polls" do
    # alias Backend.LessonsPolls.LessonPoll

    # import Backend.LessonsPollsFixtures

    # @invalid_attrs %{}

    # test "list_lessons_polls/0 returns all lessons_polls" do
    #   lesson_poll = lesson_poll_fixture()
    #   assert LessonsPolls.list_lessons_polls() == [lesson_poll]
    # end

    # test "get_lesson_poll!/1 returns the lesson_poll with given id" do
    #   lesson_poll = lesson_poll_fixture()
    #   assert LessonsPolls.get_lesson_poll!(lesson_poll.id) == lesson_poll
    # end

    # test "create_lesson_poll/1 with valid data creates a lesson_poll" do
    #   valid_attrs = %{}

    #   assert {:ok, %LessonPoll{} = lesson_poll} = LessonsPolls.create_lesson_poll(valid_attrs)
    # end

    # test "create_lesson_poll/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = LessonsPolls.create_lesson_poll(@invalid_attrs)
    # end

    # test "update_lesson_poll/2 with valid data updates the lesson_poll" do
    #   lesson_poll = lesson_poll_fixture()
    #   update_attrs = %{}

    #   assert {:ok, %LessonPoll{} = lesson_poll} = LessonsPolls.update_lesson_poll(lesson_poll, update_attrs)
    # end

    # test "update_lesson_poll/2 with invalid data returns error changeset" do
    #   lesson_poll = lesson_poll_fixture()
    #   assert {:error, %Ecto.Changeset{}} = LessonsPolls.update_lesson_poll(lesson_poll, @invalid_attrs)
    #   assert lesson_poll == LessonsPolls.get_lesson_poll!(lesson_poll.id)
    # end

    # test "delete_lesson_poll/1 deletes the lesson_poll" do
    #   lesson_poll = lesson_poll_fixture()
    #   assert {:ok, %LessonPoll{}} = LessonsPolls.delete_lesson_poll(lesson_poll)
    #   assert_raise Ecto.NoResultsError, fn -> LessonsPolls.get_lesson_poll!(lesson_poll.id) end
    # end

    # test "change_lesson_poll/1 returns a lesson_poll changeset" do
    #   lesson_poll = lesson_poll_fixture()
    #   assert %Ecto.Changeset{} = LessonsPolls.change_lesson_poll(lesson_poll)
    # end
  end
end
