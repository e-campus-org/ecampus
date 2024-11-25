defmodule Backend.LessonsTest do
  use Backend.DataCase

  alias Backend.Lessons

  alias Backend.Lessons.Lesson

  import Backend.LessonsFixtures

  import Backend.SubjectsFixtures

  describe "lessons" do
    @invalid_attrs %{description: nil, title: nil, topic: nil, is_draft: nil}

    test "list_lessons/0 returns all lessons" do
      lesson = create_lesson()
      {:ok, %{list: list}} = Lessons.list_lessons()
      assert list == [lesson]
    end

    test "get_lesson!/1 returns the lesson with given id" do
      lesson = create_lesson()
      assert Lessons.get_lesson!(lesson.id) == lesson
    end

    test "create_lesson/1 with valid data creates a lesson" do
      subject = subject_fixture()

      valid_attrs = %{
        title: "some title",
        topic: "some topic",
        is_draft: true,
        subject_id: subject.id
      }

      assert {:ok, %Lesson{} = lesson} = Lessons.create_lesson(valid_attrs)
      assert lesson.title == valid_attrs.title
      assert lesson.topic == valid_attrs.topic
      assert lesson.is_draft == true
    end

    test "create_lesson/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lessons.create_lesson(@invalid_attrs)
    end

    test "update_lesson/2 with valid data updates the lesson" do
      lesson = create_lesson()

      update_attrs = %{title: "some updated title", topic: "some updated topic", is_draft: false}

      assert {:ok, %Lesson{} = lesson} = Lessons.update_lesson(lesson, update_attrs)
      assert lesson.title == update_attrs.title
      assert lesson.topic == update_attrs.topic
      assert lesson.is_draft == update_attrs.is_draft
    end

    test "update_lesson/2 with invalid data returns error changeset" do
      lesson = create_lesson()
      assert {:error, %Ecto.Changeset{}} = Lessons.update_lesson(lesson, @invalid_attrs)
      assert lesson == Lessons.get_lesson!(lesson.id)
    end

    test "delete_lesson/1 deletes the lesson" do
      lesson = create_lesson()
      assert {:ok, %Lesson{}} = Lessons.delete_lesson(lesson)
      assert_raise Ecto.NoResultsError, fn -> Lessons.get_lesson!(lesson.id) end
    end
  end

  defp create_lesson() do
    subject = subject_fixture()
    lesson_fixture(%{subject_id: subject.id})
  end
end
