defmodule InvValidator.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      InvValidatorWeb.Telemetry,
      # Start the Ecto repository
      InvValidator.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: InvValidator.PubSub},
      # Start Finch
      {Finch, name: InvValidator.Finch},
      # Start the Endpoint (http/https)
      InvValidatorWeb.Endpoint
      # Start a worker by calling: InvValidator.Worker.start_link(arg)
      # {InvValidator.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InvValidator.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    InvValidatorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
