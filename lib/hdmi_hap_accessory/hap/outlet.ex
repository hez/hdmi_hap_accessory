defmodule HdmiHapAccessory.HAP.Outlet do
  @moduledoc """
  Responsible for representing a HAP Outlet
  """

  @behaviour HAP.ValueStore

  use GenServer

  require Logger

  def start_link(config),
    do: GenServer.start_link(__MODULE__, config, name: __MODULE__)

  @impl HAP.ValueStore
  def get_value(:on), do: if(HdmiHapAccessory.TV.status(), do: {:ok, 1}, else: {:ok, 0})

  def get_value(:outlet_in_use),
    do: if(HdmiHapAccessory.TV.status(), do: {:ok, true}, else: {:ok, false})

  def get_value(val), do: Logger.error("unknown get #{inspect(val)}")

  @impl HAP.ValueStore
  def put_value(0, :on) do
    HdmiHapAccessory.TV.off()
    :ok
  end

  def put_value(1, :on) do
    HdmiHapAccessory.TV.on()
    :ok
  end

  def put_value(value, opts), do: GenServer.call(__MODULE__, {:put, value, opts})

  @impl HAP.ValueStore
  def set_change_token(change_token, opts),
    do: GenServer.call(__MODULE__, {:set_change_token, change_token, opts})

  def toggle(name), do: GenServer.call(name, {:toggle, name})

  @impl GenServer
  def init(_), do: {:ok, %{change_token: nil}}

  @impl GenServer
  def handle_call({:set_change_token, change_token, opts}, _from, state) do
    Logger.debug("new change token for #{inspect(opts)} #{inspect(change_token)}")
    {:reply, :ok, %{state | change_token: change_token}}
  end

  def handle_call({:toggle, name}, _from, state) do
    Logger.debug("toggling #{name}")
    new_on_state = if state.on == 1, do: 0, else: 1
    HAP.value_changed(state.change_token)
    {:reply, :ok, %{state | on: new_on_state}}
  end
end
