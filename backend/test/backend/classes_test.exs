defmodule Backend.ClassesTest do
  use Backend.DataCase

  alias Backend.Classes

  describe "classes" do
    # alias Backend.Classes.Class

    # import Backend.ClassesFixtures

    # @invalid_attrs %{begin_date: nil, classroom: nil}

    # test "list_classes/0 returns all classes" do
    #   class = class_fixture()
    #   assert Classes.list_classes() == [class]
    # end

    # test "get_class!/1 returns the class with given id" do
    #   class = class_fixture()
    #   assert Classes.get_class!(class.id) == class
    # end

    # test "create_class/1 with valid data creates a class" do
    #   valid_attrs = %{begin_date: ~U[2024-08-11 20:26:00Z], classroom: "some classroom"}

    #   assert {:ok, %Class{} = class} = Classes.create_class(valid_attrs)
    #   assert class.begin_date == ~U[2024-08-11 20:26:00Z]
    #   assert class.classroom == "some classroom"
    # end

    # test "create_class/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Classes.create_class(@invalid_attrs)
    # end

    # test "update_class/2 with valid data updates the class" do
    #   class = class_fixture()
    #   update_attrs = %{begin_date: ~U[2024-08-12 20:26:00Z], classroom: "some updated classroom"}

    #   assert {:ok, %Class{} = class} = Classes.update_class(class, update_attrs)
    #   assert class.begin_date == ~U[2024-08-12 20:26:00Z]
    #   assert class.classroom == "some updated classroom"
    # end

    # test "update_class/2 with invalid data returns error changeset" do
    #   class = class_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Classes.update_class(class, @invalid_attrs)
    #   assert class == Classes.get_class!(class.id)
    # end

    # test "delete_class/1 deletes the class" do
    #   class = class_fixture()
    #   assert {:ok, %Class{}} = Classes.delete_class(class)
    #   assert_raise Ecto.NoResultsError, fn -> Classes.get_class!(class.id) end
    # end

    # test "change_class/1 returns a class changeset" do
    #   class = class_fixture()
    #   assert %Ecto.Changeset{} = Classes.change_class(class)
    # end
  end
end
