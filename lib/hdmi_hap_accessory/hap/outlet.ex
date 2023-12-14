defmodule HDMIHAPAccessory.HAP.Outlet do
  @moduledoc """
  Responsible for representing a HAP Outlet
  """

  @behaviour HAP.ValueStore

  use GenServer

  require Logger

  def start_link(config),
    do: GenServer.start_link(__MODULE__, config, name: __MODULE__)

  @impl HAP.ValueStore
  def get_value(:on), do: {:ok, HDMIHAPAccessory.TV.on?()}

  def get_value(:outlet_in_use), do: {:ok, true}

  def get_value(val), do: Logger.error("unknown get #{inspect(val)}")

  @impl HAP.ValueStore
  def put_value(0, :on), do: put_value(false, :on)
  def put_value(1, :on), do: put_value(true, :on)
  def put_value(false, :on), do: HDMIHAPAccessory.TV.off()
  def put_value(true, :on), do: HDMIHAPAccessory.TV.on()

  def put_value(value, opts),
    do: Logger.error("unknown put #{inspect(value)} and #{inspect(opts)}")

  @impl HAP.ValueStore
  def set_change_token(change_token, name),
    do: GenServer.call(__MODULE__, {:set_change_token, change_token, name})

  @impl GenServer
  def init(_), do: {:ok, %{change_tokens: %{on: nil, outlet_in_use: nil}}}

  @impl GenServer
  def handle_call({:put, :on, _value} = params, _from, state) do
    Logger.info("HAP.value_changed/1 called because #{inspect(params)}")
    HAP.value_changed(state.change_tokens.on)
    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_call({:set_change_token, change_token, name}, _from, state) do
    Logger.info("new change token for #{inspect(name)} #{inspect(change_token)}")
    {:reply, :ok, %{state | change_tokens: Map.put(state.change_tokens, name, change_token)}}
  end
end
