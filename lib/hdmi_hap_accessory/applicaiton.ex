defmodule HDMIHAPAccessory.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: HDMIHAPAccessory.TaskSupervisor},
      {HDMIHAPAccessory.TV, false},
      HDMIHAPAccessory.HAP.Outlet,
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
                 on: {HDMIHAPAccessory.HAP.Outlet, :on},
                 outlet_in_use: {HDMIHAPAccessory.HAP.Outlet, :outlet_in_use}
               }
             ]
           }
         ]
       }}
    ]

    Logger.add_handlers(:hdmi_hap_accessory)
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HDMIHapAccessory.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
