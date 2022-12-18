#!/bin/sh

cd /home/pi/hdmi_hap_accessory
. bin/config.sh
_build/prod/rel/hdmi_hap_accessory/bin/hdmi_hap_accessory start >> logs/stdout.log 2>&1
