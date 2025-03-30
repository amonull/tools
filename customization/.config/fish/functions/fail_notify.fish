function fail_notify
    notify-send -i /usr/share/icons/Papirus/16x16/status/package-remove.svg "$argv[1]" "$argv[2]" -u critical -t 10000
end
