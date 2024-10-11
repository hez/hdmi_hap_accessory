# HDMIHAPAccessory

A simple HAP (Homekit) service to turn on and off a TV via HDMI CEC.

## Building

- `MIX_ENV=prod mix build`
- Restart service `sudo systemctl restart hdmi_hap_accessory.service`

### Configure

#### Raspberry pi

- Disable screen blanking in `raspi-config`
- On the latest Raspberry Pi this helped: `/boot/config.txt` -> change `dtoverlay=vc4-kms-v3d` to `dtoverlay=vc4-fkms-v3d`

#### Application config

add your CEC address `bin/config.sh`, find by running `echo "scan" | cec-client RPI -s -d 1`

```
export CEC_ADDRESS=xxx
```

### Installing service

- Copy service to systemd directory `sudo cp hdmi_hap_accessory.service /lib/systemd/system/`
- Restart systemd `sudo systemctl daemon-reload`
- Enable service `sudo systemctl enable hdmi_hap_accessory.service`
- And reboot

### Getting the HAP pairing code again

```elixir
HAP.Display.update_pairing_info_display()
```
