defmodule CalenDaze.Appointments.Appointment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "appointments" do
    field :auhorized, :boolean, default: false
    field :end_time, :naive_datetime
    field :start_time, :naive_datetime
    field :business_id, :binary_id
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(appointment, attrs) do
    appointment
    |> cast(attrs, [:auhorized, :start_time, :end_time])
    |> validate_required([:auhorized, :start_time, :end_time])
  end
end
