defmodule CalenDaze.AppointmentsTest do
  use CalenDaze.DataCase

  alias CalenDaze.Appointments

  describe "appointments" do
    alias CalenDaze.Appointments.Appointment

    import CalenDaze.AppointmentsFixtures

    @invalid_attrs %{auhorized: nil, end_time: nil, start_time: nil}

    test "list_appointments/0 returns all appointments" do
      appointment = appointment_fixture()
      assert Appointments.list_appointments() == [appointment]
    end

    test "get_appointment!/1 returns the appointment with given id" do
      appointment = appointment_fixture()
      assert Appointments.get_appointment!(appointment.id) == appointment
    end

    test "create_appointment/1 with valid data creates a appointment" do
      valid_attrs = %{auhorized: true, end_time: ~N[2024-02-16 22:51:00], start_time: ~N[2024-02-16 22:51:00]}

      assert {:ok, %Appointment{} = appointment} = Appointments.create_appointment(valid_attrs)
      assert appointment.auhorized == true
      assert appointment.end_time == ~N[2024-02-16 22:51:00]
      assert appointment.start_time == ~N[2024-02-16 22:51:00]
    end

    test "create_appointment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Appointments.create_appointment(@invalid_attrs)
    end

    test "update_appointment/2 with valid data updates the appointment" do
      appointment = appointment_fixture()
      update_attrs = %{auhorized: false, end_time: ~N[2024-02-17 22:51:00], start_time: ~N[2024-02-17 22:51:00]}

      assert {:ok, %Appointment{} = appointment} = Appointments.update_appointment(appointment, update_attrs)
      assert appointment.auhorized == false
      assert appointment.end_time == ~N[2024-02-17 22:51:00]
      assert appointment.start_time == ~N[2024-02-17 22:51:00]
    end

    test "update_appointment/2 with invalid data returns error changeset" do
      appointment = appointment_fixture()
      assert {:error, %Ecto.Changeset{}} = Appointments.update_appointment(appointment, @invalid_attrs)
      assert appointment == Appointments.get_appointment!(appointment.id)
    end

    test "delete_appointment/1 deletes the appointment" do
      appointment = appointment_fixture()
      assert {:ok, %Appointment{}} = Appointments.delete_appointment(appointment)
      assert_raise Ecto.NoResultsError, fn -> Appointments.get_appointment!(appointment.id) end
    end

    test "change_appointment/1 returns a appointment changeset" do
      appointment = appointment_fixture()
      assert %Ecto.Changeset{} = Appointments.change_appointment(appointment)
    end
  end
end
