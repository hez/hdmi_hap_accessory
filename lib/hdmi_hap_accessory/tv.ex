defmodule HdmiHapAccessory.TV do
  @moduledoc """
  Holds the state of the TV and issues CEC commands
  """
  use Agent
  require Logger

  @cec_on_command "echo 'on __CEC_ADDRESS__' | cec-client -s -d 1"
  @cec_off_command "echo 'standby __CEC_ADDRESS__' | cec-client -s -d 1"

  def start_link(initial_value), do: Agent.start_link(fn -> initial_value end, name: __MODULE__)

  def status, do: Agent.get(__MODULE__, & &1)

  def on do
    @cec_on_command |> String.replace("__CEC_ADDRESS__", cec_address()) |> cmd_exec() |> log()
    Agent.update(__MODULE__, fn _ -> {true} end)
  end

  def off do
    @cec_off_command |> String.replace("__CEC_ADDRESS__", cec_address()) |> cmd_exec() |> log()
    Agent.update(__MODULE__, fn _ -> {false} end)
  end

  defp log(value) do
    Logger.warn(inspect(value))
  end

  if Mix.env() == :dev do
    def cmd_exec(cmd), do: Logger.debug("Executing #{inspect(cmd)}")
  else
    def cmd_exec(cmd), do: System.shell(cmd)
  end

  defp cec_address,
    do: :hdmi_hap_accessory |> Application.get_env(__MODULE__) |> Keyword.get(:cec_address)
end
