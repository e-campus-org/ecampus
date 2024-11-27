defmodule Backend.ClassesTest do
  use Backend.DataCase

  alias Backend.Classes

  alias Backend.Classes.Class

  import Backend.AccountsFixtures

  import Backend.ClassesFixtures

  import Backend.LessonsFixtures

  import Backend.SubjectsFixtures

  import Backend.GroupsFixtures

  describe "classes" do
    @invalid_attrs %{begin_date: nil, classroom: nil, lesson_id: nil, group_id: nil}

    test "list_classes/0 returns all classes" do
      class = create_class()
      {:ok, %{list: list}} = Classes.list_classes()
      assert length(list) == 1
      %{id: id} = Enum.at(list, 0)
      assert id == class.id
    end

    test "get_class!/1 returns the class with given id" do
      class = create_class()
      assert Classes.get_class!(class.id) == class
    end

    test "create_class/1 with valid data creates a class" do
      group = create_group()
      lesson = create_lessson()

      valid_attrs = %{
        begin_date: ~U[2024-08-11 20:26:00Z],
        classroom: "some classroom",
        lesson_id: lesson.id,
        group_id: group.id
      }

      assert {:ok, %Class{} = class} = Classes.create_class(valid_attrs)
      assert class.begin_date == valid_attrs.begin_date
      assert class.classroom == valid_attrs.classroom
      assert class.lesson_id == valid_attrs.lesson_id
      assert class.group_id == valid_attrs.group_id
    end

    test "create_class/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Classes.create_class(@invalid_attrs)
    end

    test "update_class/2 with valid data updates the class" do
      class = create_class()
      group = create_group()
      lesson = create_lessson()

      update_attrs = %{
        begin_date: ~U[2024-08-12 20:26:00Z],
        classroom: "some updated classroom",
        lesson_id: lesson.id,
        group_id: group.id
      }

      assert {:ok, %Class{} = class} = Classes.update_class(class, update_attrs)
      assert class.begin_date == ~U[2024-08-12 20:26:00Z]
      assert class.classroom == "some updated classroom"
    end

    test "update_class/2 with invalid data returns error changeset" do
      class = create_class()
      assert {:error, %Ecto.Changeset{}} = Classes.update_class(class, @invalid_attrs)
      assert class == Classes.get_class!(class.id)
    end

    test "delete_class/1 deletes the class" do
      class = create_class()
      assert {:ok, %Class{}} = Classes.delete_class(class)
      assert_raise Ecto.NoResultsError, fn -> Classes.get_class!(class.id) end
    end

    test "link_class_with_teacher/1 returns class with linked teacher" do
      teacher = create_account()
      class = create_class()

      {:ok, %{teachers: teachers, id: id}} =
        Classes.link_class_with_teacher(%{taught_by_id: teacher.id, class_id: class.id})

      assert id == class.id

      assert Enum.at(teachers, 0) == teacher
    end
  end

  defp create_account() do
    account_fixture(%{roles: [:teacher]})
  end

  defp create_group() do
    group_fixture()
  end

  defp create_lessson() do
    subject = subject_fixture()
    lesson_fixture(%{subject_id: subject.id})
  end

  defp create_class() do
    subject = subject_fixture()
    lesson = lesson_fixture(%{subject_id: subject.id})
    group = group_fixture()
    class_fixture(%{lesson_id: lesson.id, group_id: group.id})
  end
end
