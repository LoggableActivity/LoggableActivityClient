defmodule LoggableActivity.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LoggableActivityWeb.Telemetry,
      LoggableActivity.Repo,
      {DNSCluster, query: Application.get_env(:loggable_activity, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LoggableActivity.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LoggableActivity.Finch},
      # Start a worker by calling: LoggableActivity.Worker.start_link(arg)
      # {LoggableActivity.Worker, arg},
      # Start to serve requests, typically the last entry
      LoggableActivityWeb.Endpoint,
      LoggableActivity.BroadwayUserConsumer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LoggableActivity.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LoggableActivityWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
