defmodule Webbase.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WebbaseWeb.Telemetry,
      Webbase.Repo,
      {DNSCluster, query: Application.get_env(:webbase, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Webbase.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Webbase.Finch},
      # Start a worker by calling: Webbase.Worker.start_link(arg)
      # {Webbase.Worker, arg},
      # Start to serve requests, typically the last entry
      WebbaseWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Webbase.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WebbaseWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
