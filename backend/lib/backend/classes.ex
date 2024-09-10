defmodule Backend.Classes do
  @moduledoc """
  The Classes context.
  """

  import Ecto.Query, warn: false
  import Backend.Pagination
  alias Backend.Repo

  alias Backend.Classes.Class
  alias Backend.TaughtClasses.TaughtClass

  @doc """
  Returns the list of classes.

  ## Examples

      iex> list_classes()
      [%Class{}, ...]

  """
  def list_classes(params \\ %{}) do
    filters =
      Class
      |> join(:inner, [c], l in assoc(c, :lesson))

    filters =
      params
      |> Enum.reduce(filters, fn
        {"group_id", group_id}, query ->
          query |> where([c], c.group_id == ^group_id)

        {"lesson_id", lesson_id}, query ->
          query |> where([c], c.lesson_id == ^lesson_id)

        {"classroom", classroom}, query ->
          query |> where([c], ilike(c.classroom, ^"%#{classroom}%"))

        {"subject_id", subject_id}, query ->
          query |> where([c, l], l.subject_id == ^subject_id)

        _, query ->
          query
      end)

    filters
    |> preload([c, l], [:group, lesson: l])
    |> Flop.validate_and_run(
      %{
        page: Map.get(params, "page", 1),
        page_size: Map.get(params, "page_size", 10)
      },
      for: Class
    )
    |> with_pagination()
  end

  @doc """
  Gets a single class.

  Raises `Ecto.NoResultsError` if the Class does not exist.

  ## Examples

      iex> get_class!(123)
      %Class{}

      iex> get_class!(456)
      ** (Ecto.NoResultsError)

  """
  def get_class!(id),
    do:
      Repo.get!(Class, id)
      |> Repo.preload([
        :group,
        :teachers,
        :lesson,
        lesson: [
          :topics,
          :quizzes,
          :subject,
          quizzes: [:questions, questions: [:answers, :answered_questions, :quizzes_questions]],
          subject: [:teachers]
        ]
      ])

  @doc """
  Creates a class.

  ## Examples

      iex> create_class(%{field: value})
      {:ok, %Class{}}

      iex> create_class(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_class(attrs \\ %{}) do
    %Class{}
    |> Class.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a class.

  ## Examples

      iex> update_class(class, %{field: new_value})
      {:ok, %Class{}}

      iex> update_class(class, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_class(%Class{} = class, attrs) do
    class
    |> Class.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a class.

  ## Examples

      iex> delete_class(class)
      {:ok, %Class{}}

      iex> delete_class(class)
      {:error, %Ecto.Changeset{}}

  """
  def delete_class(%Class{} = class) do
    Repo.delete(class)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking class changes.

  ## Examples

      iex> change_class(class)
      %Ecto.Changeset{data: %Class{}}

  """
  def change_class(%Class{} = class, attrs \\ %{}) do
    Class.changeset(class, attrs)
  end

  @doc """
  Links subject with teacher and group.

  ## Examples

      iex> link_class_with_teacher(%{field: value})
      {:ok, %TaughtSubject{}}

      iex> link_class_with_teacher(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def link_class_with_teacher(attrs) do
    changeset =
      %TaughtClass{}
      |> TaughtClass.changeset(attrs)

    with {:ok, taught_class} <- Repo.insert(changeset) do
      {:ok, get_class!(taught_class.class_id)}
    end
  end
end
