defmodule CalenDaze.Repo.Migrations.CreateAppointments do
  use Ecto.Migration

  def change do
    create table(:appointments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :auhorized, :boolean, default: false, null: false
      add :start_time, :naive_datetime
      add :end_time, :naive_datetime
      add :business_id, references(:businesses, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:appointments, [:business_id])
    create index(:appointments, [:user_id])
  end
end
