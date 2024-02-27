defmodule CalenDaze.Repo.Migrations.AddFieldsToCalendarConfig do
  use Ecto.Migration

  def change do
    alter table(:calendar_confs) do
      add :appointment_types, :map
      add :should_approve_appointments, :boolean, default: true
    end
  end
end
