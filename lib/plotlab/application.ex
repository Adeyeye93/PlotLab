defmodule Plotlab.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PlotlabWeb.Telemetry,
      Plotlab.Repo,
      {DNSCluster, query: Application.get_env(:plotlab, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Plotlab.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Plotlab.Finch},
      # Start a worker by calling: Plotlab.Worker.start_link(arg)
      # {Plotlab.Worker, arg},
      # Start to serve requests, typically the last entry
      PlotlabWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Plotlab.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PlotlabWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
