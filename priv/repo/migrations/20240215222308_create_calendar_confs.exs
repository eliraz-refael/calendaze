defmodule CalenDaze.Repo.Migrations.CreateCalendarConfs do
  use Ecto.Migration

  def change do
    create table(:calendar_confs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :work_hours, :map
      add :business_id, references(:businesses, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:calendar_confs, [:business_id])
  end
end
