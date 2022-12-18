# HdmiHapAccessory

A simple HAP/web service to turn on and off a TV via HDMI.

## Building

- `MIX_ENV=prod mix deps.get`
- `MIX_ENV=prod mix compile`
- `MIX_ENV=prod mix release`

### Configure

add this to your bin/config.sh

`export CEC_ADDRESS=xxx`

### Installing service

- Copy service to systemd directory `sudo cp hdmi_hap_accessory.service /lib/systemd/system/`
- Restart systemd `sudo systemctl daemon-reload`
- Enable Homehub `sudo systemctl enable hdmi_hap_accessory.service`
- And reboot
