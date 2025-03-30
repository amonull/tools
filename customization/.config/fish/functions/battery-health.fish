function battery-health
  set bat_full_des $(cat /sys/class/power_supply/BAT0/energy_full_design)
  set bat_full $(cat /sys/class/power_supply/BAT0/energy_full)
  echo $(math $bat_full / $bat_full_des x 100)"%"
end
