defmodule DynuReporter.Application do
  @moduledoc false

  use Application
  require Logger


  alias DynuReporter.Heartbeat

  def start(_type, args) do
    children = [
      {Heartbeat, args},
      {SystemRegistry.Task,
       [
         [:state, :network_interface, "wlan0", :ipv4_address],
         fn {_old, _new} ->
           DynuReporter.Heartbeat.update_now
         end
       ]}        
    ]

    opts = [strategy: :one_for_one, name: DynuReporter.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
