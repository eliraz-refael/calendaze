defmodule CalenDaze.Business do
  @moduledoc """
  The Business context.
  """

  import Ecto.Query, warn: false
  alias CalenDaze.Repo

  alias CalenDaze.Business.CalendarConf

  @doc """
  Returns the list of calendar_confs.

  ## Examples

      iex> list_calendar_confs()
      [%CalendarConf{}, ...]

  """
  def list_calendar_confs do
    Repo.all(CalendarConf)
  end

  @doc """
  Gets a single calendar_conf.

  Raises `Ecto.NoResultsError` if the Calendar conf does not exist.

  ## Examples

      iex> get_calendar_conf!(123)
      %CalendarConf{}

      iex> get_calendar_conf!(456)
      ** (Ecto.NoResultsError)

  """
  def get_calendar_conf!(id), do: Repo.get!(CalendarConf, id)

  @doc """
  Creates a calendar_conf.

  ## Examples

      iex> create_calendar_conf(%{field: value})
      {:ok, %CalendarConf{}}

      iex> create_calendar_conf(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_calendar_conf(attrs \\ %{}) do
    %CalendarConf{}
    |> CalendarConf.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a calendar_conf.

  ## Examples

      iex> update_calendar_conf(calendar_conf, %{field: new_value})
      {:ok, %CalendarConf{}}

      iex> update_calendar_conf(calendar_conf, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_calendar_conf(%CalendarConf{} = calendar_conf, attrs) do
    calendar_conf
    |> CalendarConf.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a calendar_conf.

  ## Examples

      iex> delete_calendar_conf(calendar_conf)
      {:ok, %CalendarConf{}}

      iex> delete_calendar_conf(calendar_conf)
      {:error, %Ecto.Changeset{}}

  """
  def delete_calendar_conf(%CalendarConf{} = calendar_conf) do
    Repo.delete(calendar_conf)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking calendar_conf changes.

  ## Examples

      iex> change_calendar_conf(calendar_conf)
      %Ecto.Changeset{data: %CalendarConf{}}

  """
  def change_calendar_conf(%CalendarConf{} = calendar_conf, attrs \\ %{}) do
    CalendarConf.changeset(calendar_conf, attrs)
  end
end
