import Config

config :hdmi_hap_accessory, HDMIHAPAccessory.TV, cec_address: System.get_env("CEC_ADDRESS")
