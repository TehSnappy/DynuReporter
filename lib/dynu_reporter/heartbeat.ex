defmodule DynuReporter.Heartbeat do
  @moduledoc false

  use GenServer
  require Logger

  alias DynuReporter.Heartbeat
  alias DynuReporter.State
  alias HTTPoison.Response
  alias HTTPoison.Error

  @http_adapter Application.get_env(:dynu_reporter, :http_adapter, HTTPoison)
  @dynu_api_uri "https://api.dynu.com/nic/update?"

  def start_link([]) do
    GenServer.start_link(__MODULE__, initial_state(), name: Heartbeat)
  end

  def init(state) do
    HTTPoison.start()

    # force a quick update on start, but don't persist it
    schedule_heartbeat(%{state | polling_interval: 100})

    {:ok, state}
  end

  def get_state do
    GenServer.call(Heartbeat, :get_state)
  end

  def stop_polling() do
    GenServer.call(Heartbeat, :stop_polling)
  end

  def handle_call(:get_state, _, state = %State{}) do
    {:reply, state, state}
  end

  def handle_call(:stop_polling, _, state = %State{}) do
    updated_state = %{state | polling_interval: 0}
    {:reply, updated_state, updated_state}
  end

  def handle_info(:heartbeat, state = %State{}) do
    new_state =
      state
      |> beat()
      |> schedule_heartbeat()

    {:noreply, new_state}
  end

  defp schedule_heartbeat(state = %State{polling_interval: 0}) do
    state
  end

  defp schedule_heartbeat(state = %State{polling_interval: polling_interval}) do
    Process.send_after(self(), :heartbeat, polling_interval)
    state
  end

  defp beat(state = %State{}) do
    update_domains(state)
  end

  defp update_domains(state = %State{last_success: last_success}) do
    state
    |> build_update_uri()
    |> @http_adapter.get()
    |> case do
      {:ok, %Response{body: "nochg"}} ->
        if is_nil(last_success) do
          Logger.info("dynu_reporter: DNS unchanged")
        end

        State.report_success(state)

      {:ok, %Response{body: "good"}} ->
        Logger.info("dynu_reporter: DNS updated")
        State.report_success(state)

      {:ok, %Response{body: message}} ->
        Logger.error("dynu_reporter: DNS failed. #{message}")
        State.report_error(state)

      {:error, %Error{reason: reason}} ->
        Logger.error("dynu_reporter: http error. #{inspect(reason)}")
        State.report_error(state)

      other ->
        Logger.error("dynu_reporter: Unknown error. #{inspect(other)}")
        State.report_error(state)
    end
  end

  defp build_update_uri(%State{user_name: user_name, password: password, location: location}) do
    @dynu_api_uri <>
      "&username=#{user_name}" <>
      "&location=#{location}" <>
      "&password=#{password}"
  end

  defp initial_state() do
    %State{
      user_name: Application.get_env(:dynu_reporter, :user_name),
      password: Application.get_env(:dynu_reporter, :password),
      location: Application.get_env(:dynu_reporter, :location),
      polling_interval: Application.get_env(:dynu_reporter, :polling_interval, 0)
    }
  end
end
