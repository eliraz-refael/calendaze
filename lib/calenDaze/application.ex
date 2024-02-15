defmodule CalenDaze.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CalenDazeWeb.Telemetry,
      # Start the Ecto repository
      CalenDaze.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: CalenDaze.PubSub},
      # Start Finch
      {Finch, name: CalenDaze.Finch},
      # Start the Endpoint (http/https)
      CalenDazeWeb.Endpoint
      # Start a worker by calling: CalenDaze.Worker.start_link(arg)
      # {CalenDaze.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CalenDaze.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CalenDazeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
