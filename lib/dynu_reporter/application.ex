defmodule DynuReporter.Application do
  @moduledoc false

  use Application

  alias DynuReporter.Heartbeat

  def start(_type, args) do
    children = [
      {Heartbeat, args}
    ]

    opts = [strategy: :one_for_one, name: DynuReporter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
