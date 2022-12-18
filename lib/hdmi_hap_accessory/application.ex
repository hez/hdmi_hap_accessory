defmodule HdmiHapAccessory.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      HdmiHapAccessoryWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: HdmiHapAccessory.PubSub},
      # Start Finch
      {Finch, name: HdmiHapAccessory.Finch},
      # Start the Endpoint (http/https)
      HdmiHapAccessoryWeb.Endpoint,
      # Start a worker by calling: HdmiHapAccessory.Worker.start_link(arg)
      # {HdmiHapAccessory.Worker, arg}
      {HdmiHapAccessory.TV, false},
      HdmiHapAccessory.HAP.Outlet,
      {HAP,
       %HAP.AccessoryServer{
         name: "HDMI Outlet",
         model: "HDMIOutlet",
         identifier: "11:22:33:44:12:66",
         accessory_type: 7,
         accessories: [
           %HAP.Accessory{
             name: "HDMI TV",
             services: [
               %HAP.Services.Outlet{
                 name: "HDMI TV",
                 on: {HdmiHapAccessory.HAP.Outlet, :on},
                 outlet_in_use: {HdmiHapAccessory.HAP.Outlet, :outlet_in_use}
               }
             ]
           }
         ]
       }}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HdmiHapAccessory.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HdmiHapAccessoryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
