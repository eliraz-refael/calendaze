defmodule CalenDaze.Repo do
  use Ecto.Repo,
    otp_app: :calenDaze,
    adapter: Ecto.Adapters.Postgres
end
