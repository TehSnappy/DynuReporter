defmodule DynuReporterTest do
  use ExUnit.Case

  test "reads values from config" do
    assert %{
             location: "DOMAIN_LOCATION",
             password: "UPDATE_PASSWORD",
             user_name: "USER_NAME"
           } = DynuReporter.get_state()
  end

  test "posts a request on launch" do
    Process.sleep(200)

    %{
      last_success: last_success
    } = DynuReporter.get_state()

    assert %DateTime{} = last_success
  end

  test "repeats based on polling_interval" do
    Process.sleep(200)

    %{
      last_success: last_success
    } = DynuReporter.get_state()

    Process.sleep(1000)

    %{
      last_success: last_success_2
    } = DynuReporter.get_state()

    assert %DateTime{} = last_success_2
    assert last_success != last_success_2
  end

  test "repeat can be turned off" do
    DynuReporter.stop_polling()

    Process.sleep(1000)

    %{
      last_success: last_success
    } = DynuReporter.get_state()

    Process.sleep(1000)

    %{
      last_success: last_success_2
    } = DynuReporter.get_state()

    assert %DateTime{} = last_success_2
    assert last_success == last_success_2
  end
end
