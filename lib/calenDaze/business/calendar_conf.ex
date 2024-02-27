defmodule CalenDaze.Business.CalendarConf do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "calendar_confs" do
    field :work_hours, :map
    field :business_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(calendar_conf, attrs) do
    calendar_conf
    |> cast(attrs, [:work_hours])
    |> validate_required([])
  end
end
