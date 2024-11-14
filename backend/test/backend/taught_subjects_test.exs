defmodule Backend.TaughtSubjectsTest do
  use Backend.DataCase

  alias Backend.TaughtSubjects

  describe "taught_subjects" do
    # alias Backend.TaughtSubjects.TaughtSubject

    # import Backend.TaughtSubjectsFixtures

    # @invalid_attrs %{}

    # test "list_taught_subjects/0 returns all taught_subjects" do
    #   taught_subject = taught_subject_fixture()
    #   assert TaughtSubjects.list_taught_subjects() == [taught_subject]
    # end

    # test "get_taught_subject!/1 returns the taught_subject with given id" do
    #   taught_subject = taught_subject_fixture()
    #   assert TaughtSubjects.get_taught_subject!(taught_subject.id) == taught_subject
    # end

    # test "create_taught_subject/1 with valid data creates a taught_subject" do
    #   valid_attrs = %{}

    #   assert {:ok, %TaughtSubject{} = taught_subject} = TaughtSubjects.create_taught_subject(valid_attrs)
    # end

    # test "create_taught_subject/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = TaughtSubjects.create_taught_subject(@invalid_attrs)
    # end

    # test "update_taught_subject/2 with valid data updates the taught_subject" do
    #   taught_subject = taught_subject_fixture()
    #   update_attrs = %{}

    #   assert {:ok, %TaughtSubject{} = taught_subject} = TaughtSubjects.update_taught_subject(taught_subject, update_attrs)
    # end

    # test "update_taught_subject/2 with invalid data returns error changeset" do
    #   taught_subject = taught_subject_fixture()
    #   assert {:error, %Ecto.Changeset{}} = TaughtSubjects.update_taught_subject(taught_subject, @invalid_attrs)
    #   assert taught_subject == TaughtSubjects.get_taught_subject!(taught_subject.id)
    # end

    # test "delete_taught_subject/1 deletes the taught_subject" do
    #   taught_subject = taught_subject_fixture()
    #   assert {:ok, %TaughtSubject{}} = TaughtSubjects.delete_taught_subject(taught_subject)
    #   assert_raise Ecto.NoResultsError, fn -> TaughtSubjects.get_taught_subject!(taught_subject.id) end
    # end

    # test "change_taught_subject/1 returns a taught_subject changeset" do
    #   taught_subject = taught_subject_fixture()
    #   assert %Ecto.Changeset{} = TaughtSubjects.change_taught_subject(taught_subject)
    # end
  end
end
