defmodule App.TimeContext do
  @moduledoc """
  The TimeContext context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.TimeContext.WorkingTime

  @doc """
  Returns the list of workingtimes.

  ## Examples

      iex> list_workingtimes()
      [%WorkingTime{}, ...]

  """
  def list_workingtimes do
    Repo.all(WorkingTime)
  end

  @doc """
  Gets a single working_time.

  Raises `Ecto.NoResultsError` if the Working time does not exist.

  ## Examples

      iex> get_working_time!(123)
      %WorkingTime{}

      iex> get_working_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_working_time!(id), do: Repo.get!(WorkingTime, id)

  def get_working_time_by_user(user, start, endTime) do
    Repo.all(
      from w in WorkingTime,
      where: w.user == ^user
      and w.start >= ^start
      and w.start <= ^endTime
    )
  end

  @doc """
  Creates a working_time.

  ## Examples

      iex> create_working_time(%{field: value})
      {:ok, %WorkingTime{}}

      iex> create_working_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_working_time(attrs \\ %{}) do
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a working_time.

  ## Examples

      iex> update_working_time(working_time, %{field: new_value})
      {:ok, %WorkingTime{}}

      iex> update_working_time(working_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working_time.

  ## Examples

      iex> delete_working_time(working_time)
      {:ok, %WorkingTime{}}

      iex> delete_working_time(working_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_time changes.

  ## Examples

      iex> change_working_time(working_time)
      %Ecto.Changeset{data: %WorkingTime{}}

  """
  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end

  alias App.TimeContext.Clocks

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clocks{}, ...]

  """
  def list_clocks do
    Repo.all(Clocks)
  end

  def get_clocks_by_user(userID) do
    Repo.all(
      from c in Clocks,
      where: c.user == ^userID
    )
  end

  @doc """
  Gets a single clocks.

  Raises `Ecto.NoResultsError` if the Clocks does not exist.

  ## Examples

      iex> get_clocks!(123)
      %Clocks{}

      iex> get_clocks!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clocks!(id), do: Repo.get!(Clocks, id)

  def get_clock_of_user(user) do
    Repo.one(
      from c in Clocks,
      where: c.user == ^user
    )
  end

  @doc """
  Creates a clocks.

  ## Examples

      iex> create_clocks(%{field: value})
      {:ok, %Clocks{}}

      iex> create_clocks(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clocks(attrs \\ %{}) do
    %Clocks{}
    |> Clocks.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a clocks.

  ## Examples

      iex> update_clocks(clocks, %{field: new_value})
      {:ok, %Clocks{}}

      iex> update_clocks(clocks, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clocks(%Clocks{} = clocks, attrs) do
    clocks
    |> Clocks.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clocks.

  ## Examples

      iex> delete_clocks(clocks)
      {:ok, %Clocks{}}

      iex> delete_clocks(clocks)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clocks(%Clocks{} = clocks) do
    Repo.delete(clocks)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clocks changes.

  ## Examples

      iex> change_clocks(clocks)
      %Ecto.Changeset{data: %Clocks{}}

  """
  def change_clocks(%Clocks{} = clocks, attrs \\ %{}) do
    Clocks.changeset(clocks, attrs)
  end
end
