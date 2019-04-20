defmodule DynuReporter.State do
  @moduledoc false

  defstruct last_success: nil,
            last_error: nil,
            user_name: nil,
            password: nil,
            location: nil,
            polling_interval: 0

  def report_success(state) do
    %{state | last_success: DateTime.utc_now()}
  end

  def report_error(state) do
    %{state | last_error: DateTime.utc_now()}
  end
end
