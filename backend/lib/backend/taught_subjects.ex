defmodule Backend.TaughtSubjects do
  @moduledoc """
  The TaughtSubjects context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.TaughtSubjects.TaughtSubject

  @doc """
  Returns the list of taught_subjects.

  ## Examples

      iex> list_taught_subjects()
      [%TaughtSubject{}, ...]

  """
  def list_taught_subjects do
    Repo.all(TaughtSubject)
  end

  @doc """
  Gets a single taught_subject.

  Raises `Ecto.NoResultsError` if the Taught subject does not exist.

  ## Examples

      iex> get_taught_subject!(123)
      %TaughtSubject{}

      iex> get_taught_subject!(456)
      ** (Ecto.NoResultsError)

  """
  def get_taught_subject!(id), do: Repo.get!(TaughtSubject, id)

  @doc """
  Creates a taught_subject.

  ## Examples

      iex> create_taught_subject(%{field: value})
      {:ok, %TaughtSubject{}}

      iex> create_taught_subject(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_taught_subject(attrs \\ %{}) do
    %TaughtSubject{}
    |> TaughtSubject.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a taught_subject.

  ## Examples

      iex> update_taught_subject(taught_subject, %{field: new_value})
      {:ok, %TaughtSubject{}}

      iex> update_taught_subject(taught_subject, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_taught_subject(%TaughtSubject{} = taught_subject, attrs) do
    taught_subject
    |> TaughtSubject.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a taught_subject.

  ## Examples

      iex> delete_taught_subject(taught_subject)
      {:ok, %TaughtSubject{}}

      iex> delete_taught_subject(taught_subject)
      {:error, %Ecto.Changeset{}}

  """
  def delete_taught_subject(%TaughtSubject{} = taught_subject) do
    Repo.delete(taught_subject)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking taught_subject changes.

  ## Examples

      iex> change_taught_subject(taught_subject)
      %Ecto.Changeset{data: %TaughtSubject{}}

  """
  def change_taught_subject(%TaughtSubject{} = taught_subject, attrs \\ %{}) do
    TaughtSubject.changeset(taught_subject, attrs)
  end
end
