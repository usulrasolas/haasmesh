
#pass in seconds to flash for
if [ $# -eq 0 ]; then # no args
 nsec=10
else
 nsec=$1
fi

if cat /sys/firmware/devicetree/base/model | grep -q "TP-Link Archer C7 v2"; then
echo "C7 v2"
led=/sys/class/leds/tp-link\:green\:qss
fi
if cat /sys/firmware/devicetree/base/model | grep -q "TP-Link Archer C7 v4"; then
echo "C7 v4"
led=/sys/class/leds/tp-link\:green\:wps
fi
if cat /sys/firmware/devicetree/base/model | grep -q "TP-Link Archer C7 v5"; then
echo "C7 v5"
led=/sys/class/leds/tp-link\:green\:wps
fi
if cat /sys/firmware/devicetree/base/model | grep -q "TP-Link Archer A7 v5"; then
echo "A7 v5"
led=/sys/class/leds/tp-link\:green\:wps
fi

if cat /sys/firmware/devicetree/base/model | grep -q "Linksys EA8300"; then
echo "EA8300"
 if [ -f /sys/class/leds/ea8300:white:wps/brightness ]; then
  led=/sys/class/leds/ea8300\:white\:wps
  echo none > /sys/class/leds/ea8300\:white\:linksys/trigger
else
  led=/sys/class/leds/white\:wps
  echo none > /sys/class/leds/white\:linksys/trigger
 fi
fi

if cat /sys/firmware/devicetree/base/model | grep -q "Linksys MR8300"; then
echo "MR9000"
led=/sys/class/leds/green\:panel
fi

if cat /sys/firmware/devicetree/base/model | grep -q "COMFAST CF-EW72"; then
echo "EW72"
led=/sys/class/leds/cf-ew72\:blue\:wlan
fi

if cat /sys/firmware/devicetree/base/model | grep -q "Compex WPJ419 Haas"; then
echo "IPQ4019 Haas"
#led=/sys/class/leds/green\:usb
led=/sys/class/leds/green\:wlan
fi

if cat /sys/firmware/devicetree/base/model | grep -q "Wavlink WL-WN531A6"; then
echo "Jetstream"
led=/sys/class/leds/blue\:wifi2g
fi
if cat /sys/firmware/devicetree/base/model | grep -q "Xiaomi Redmi Router AC2100"; then
echo "Redmi"
led=/sys/class/leds/white\:status
fi

if cat /sys/firmware/devicetree/base/model | grep -q "Linksys E8450"; then
echo "Belkin RT3200 or Linksys E8450"
led=/sys/class/leds/inet\:blue
fi

if cat /sys/firmware/devicetree/base/model | grep -q "WRTQ-329ACN"; then
echo "Luma"
led="none"
echo "flashing luma led ring for 2x$nsec sec"
for i in $(seq 0 $nsec); do
 i2cset -y 2 0x48 3 5 12 0 i # set luma led ring to solid purple bright
 sleep 1
 i2cset -y 2 0x48 3 5 1 0 i # set luma led ring to solid purple dim
 sleep 1
done
fi

if [ "$led" != "none" ]; then
echo "flashing led $led for 2x$nsec sec"
echo none > $led/trigger
for i in $(seq 0 $nsec); do
 echo 1 > $led/brightness
 sleep 1
 echo 0 > $led/brightness
 sleep 1
done
fi

