defmodule Backend.LessonTopicsTest do
  use Backend.DataCase

  alias Backend.LessonTopics

  alias Backend.LessonTopics.LessonTopic

  import Backend.LessonTopicsFixtures

  import Backend.LessonsFixtures

  import Backend.SubjectsFixtures

  describe "lesson_topics" do
    alias Backend.LessonTopics.LessonTopic

    import Backend.LessonTopicsFixtures

    @invalid_attrs %{title: nil, content: nil, lesson_id: nil}

    test "list_lesson_topics/0 returns all lesson_topics" do
      lesson_topic = create_lesson_topic()
      {:ok, %{list: list}} = LessonTopics.list_lesson_topics()
      assert list == [lesson_topic]
    end

    test "get_lesson_topic!/1 returns the lesson_topic with given id" do
      lesson_topic = create_lesson_topic()
      assert LessonTopics.get_lesson_topic!(lesson_topic.id) == lesson_topic
    end

    test "create_lesson_topic/1 with valid data creates a lesson_topic" do
      lesson = create_lessson()
      valid_attrs = %{title: "some title", content: %{}, lesson_id: lesson.id}

      assert {:ok, %LessonTopic{} = lesson_topic} = LessonTopics.create_lesson_topic(valid_attrs)
      assert lesson_topic.title == valid_attrs.title
      assert lesson_topic.content == valid_attrs.content
    end

    test "create_lesson_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LessonTopics.create_lesson_topic(@invalid_attrs)
    end

    test "update_lesson_topic/2 with valid data updates the lesson_topic" do
      lesson_topic = create_lesson_topic()
      update_attrs = %{title: "some updated title", content: %{"test" => "value"}}

      assert {:ok, %LessonTopic{} = lesson_topic} =
               LessonTopics.update_lesson_topic(lesson_topic, update_attrs)

      assert lesson_topic.title == update_attrs.title
      assert lesson_topic.content == update_attrs.content
    end

    test "update_lesson_topic/2 with invalid data returns error changeset" do
      lesson_topic = create_lesson_topic()

      assert {:error, %Ecto.Changeset{}} =
               LessonTopics.update_lesson_topic(lesson_topic, @invalid_attrs)

      assert lesson_topic == LessonTopics.get_lesson_topic!(lesson_topic.id)
    end

    test "delete_lesson_topic/1 deletes the lesson_topic" do
      lesson_topic = create_lesson_topic()
      assert {:ok, %LessonTopic{}} = LessonTopics.delete_lesson_topic(lesson_topic)
      assert_raise Ecto.NoResultsError, fn -> LessonTopics.get_lesson_topic!(lesson_topic.id) end
    end
  end

  defp create_lessson() do
    subject = subject_fixture()
    lesson_fixture(%{subject_id: subject.id})
  end

  defp create_lesson_topic() do
    subject = subject_fixture()
    lesson = lesson_fixture(%{subject_id: subject.id})
    lesson_topic_fixture(%{lesson_id: lesson.id})
  end
end
