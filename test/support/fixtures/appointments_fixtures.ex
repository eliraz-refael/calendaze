defmodule CalenDaze.AppointmentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CalenDaze.Appointments` context.
  """

  @doc """
  Generate a appointment.
  """
  def appointment_fixture(attrs \\ %{}) do
    {:ok, appointment} =
      attrs
      |> Enum.into(%{
        auhorized: true,
        end_time: ~N[2024-02-16 22:51:00],
        start_time: ~N[2024-02-16 22:51:00]
      })
      |> CalenDaze.Appointments.create_appointment()

    appointment
  end
end
