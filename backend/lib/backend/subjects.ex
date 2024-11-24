defmodule Backend.Subjects do
  @moduledoc """
  The Subjects context.
  """

  import Ecto.Query, warn: false
  import Backend.Pagination
  alias Backend.Repo

  alias Backend.Subjects.Subject
  alias Backend.TaughtSubjects.TaughtSubject

  @doc """
  Returns the list of subjects.

  ## Examples

      iex> list_subjects()
      [%Subject{}, ...]

  """
  def list_subjects(params \\ %{}),
    do:
      Flop.validate_and_run(Subject, params, for: Subject)
      |> with_pagination()

  @doc """
  Gets a single subject.

  Raises `Ecto.NoResultsError` if the Subject does not exist.

  ## Examples

      iex> get_subject!(123)
      %Subject{}

      iex> get_subject!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subject!(id) do
    Repo.get!(Subject, id) |> Repo.preload([:teachers])
  end

  @doc """
  Creates a subject.

  ## Examples

      iex> create_subject(%{field: value})
      {:ok, %Subject{}}

      iex> create_subject(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subject(attrs \\ %{}) do
    changeset =
      %Subject{}
      |> Subject.changeset(attrs)

    with {:ok, subject} <- Repo.insert(changeset) do
      {:ok, Repo.preload(subject, [:teachers])}
    end
  end

  @doc """
  Updates a subject.

  ## Examples

      iex> update_subject(subject, %{field: new_value})
      {:ok, %Subject{}}

      iex> update_subject(subject, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subject(%Subject{} = subject, attrs) do
    changeset =
      subject
      |> Subject.changeset(attrs)

    with {:ok, subject} <- Repo.update(changeset) do
      {:ok, Repo.preload(subject, [:teachers])}
    end
  end

  @doc """
  Deletes a subject.

  ## Examples

      iex> delete_subject(subject)
      {:ok, %Subject{}}

      iex> delete_subject(subject)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subject(%Subject{} = subject) do
    Subject.changeset(subject, %{})
    |> Ecto.Changeset.no_assoc_constraint(:lessons)
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subject changes.

  ## Examples

      iex> change_subject(subject)
      %Ecto.Changeset{data: %Subject{}}

  """
  def change_subject(%Subject{} = subject, attrs \\ %{}) do
    Subject.changeset(subject, attrs)
  end

  @doc """
  Links subject with teacher and group.

  ## Examples

      iex> link_subject_with_teacher_and_group(%{field: value})
      {:ok, %TaughtSubject{}}

      iex> link_subject_with_teacher_and_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def link_subject_with_teacher_and_group(attrs) do
    changeset =
      %TaughtSubject{}
      |> TaughtSubject.changeset(attrs)

    with {:ok, taught_subject} <- Repo.insert(changeset) do
      {:ok, Repo.preload(taught_subject, [:subject, subject: [:teachers]])}
    end
  end
end
