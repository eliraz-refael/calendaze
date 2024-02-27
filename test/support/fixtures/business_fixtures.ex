defmodule CalenDaze.BusinessFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CalenDaze.Business` context.
  """

  @doc """
  Generate a calendar_conf.
  """
  def calendar_conf_fixture(attrs \\ %{}) do
    {:ok, calendar_conf} =
      attrs
      |> Enum.into(%{
        work_hours: %{}
      })
      |> CalenDaze.Business.create_calendar_conf()

    calendar_conf
  end
end
