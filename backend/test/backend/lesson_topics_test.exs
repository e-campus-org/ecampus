defmodule Backend.LessonTopicsTest do
  use Backend.DataCase

  alias Backend.LessonTopics

  describe "lesson_topics" do
    alias Backend.LessonTopics.LessonTopic

    import Backend.LessonTopicsFixtures

    @invalid_attrs %{title: nil, content: nil}

    test "list_lesson_topics/0 returns all lesson_topics" do
      lesson_topic = lesson_topic_fixture()
      assert LessonTopics.list_lesson_topics() == [lesson_topic]
    end

    test "get_lesson_topic!/1 returns the lesson_topic with given id" do
      lesson_topic = lesson_topic_fixture()
      assert LessonTopics.get_lesson_topic!(lesson_topic.id) == lesson_topic
    end

    test "create_lesson_topic/1 with valid data creates a lesson_topic" do
      valid_attrs = %{title: "some title", content: "some content"}

      assert {:ok, %LessonTopic{} = lesson_topic} = LessonTopics.create_lesson_topic(valid_attrs)
      assert lesson_topic.title == "some title"
      assert lesson_topic.content == "some content"
    end

    test "create_lesson_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LessonTopics.create_lesson_topic(@invalid_attrs)
    end

    test "update_lesson_topic/2 with valid data updates the lesson_topic" do
      lesson_topic = lesson_topic_fixture()
      update_attrs = %{title: "some updated title", content: "some updated content"}

      assert {:ok, %LessonTopic{} = lesson_topic} = LessonTopics.update_lesson_topic(lesson_topic, update_attrs)
      assert lesson_topic.title == "some updated title"
      assert lesson_topic.content == "some updated content"
    end

    test "update_lesson_topic/2 with invalid data returns error changeset" do
      lesson_topic = lesson_topic_fixture()
      assert {:error, %Ecto.Changeset{}} = LessonTopics.update_lesson_topic(lesson_topic, @invalid_attrs)
      assert lesson_topic == LessonTopics.get_lesson_topic!(lesson_topic.id)
    end

    test "delete_lesson_topic/1 deletes the lesson_topic" do
      lesson_topic = lesson_topic_fixture()
      assert {:ok, %LessonTopic{}} = LessonTopics.delete_lesson_topic(lesson_topic)
      assert_raise Ecto.NoResultsError, fn -> LessonTopics.get_lesson_topic!(lesson_topic.id) end
    end

    test "change_lesson_topic/1 returns a lesson_topic changeset" do
      lesson_topic = lesson_topic_fixture()
      assert %Ecto.Changeset{} = LessonTopics.change_lesson_topic(lesson_topic)
    end
  end
end
