defmodule ShxtMenTools.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ShxtMenToolsWeb.Telemetry,
      ShxtMenTools.Repo,
      {DNSCluster, query: Application.get_env(:shxt_men_tools, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ShxtMenTools.PubSub},
      # Start a worker by calling: ShxtMenTools.Worker.start_link(arg)
      # {ShxtMenTools.Worker, arg},
      # Start to serve requests, typically the last entry
      ShxtMenToolsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ShxtMenTools.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ShxtMenToolsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
