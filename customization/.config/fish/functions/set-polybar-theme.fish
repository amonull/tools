function set-polybar-theme
  unlink ~/.config/polybar/config.ini
  ln -s /home/amon/.config/polybar/themes/"$argv"/config.ini /home/amon/.config/polybar/config.ini
end
