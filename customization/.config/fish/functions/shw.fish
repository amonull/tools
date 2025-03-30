# TODO:
# add check at start if ls or cat is calling to return correct --help/--version(s)

function shw
  set -l flags
  set -l files
  for item in $argv
    switch $item
    case '-*'
      set -a flags "$item"
    case '*'
      set -a files "$item"
    end
  end

  if test (count $files) -lt 1
    if type -q exa
      exa -l --git --group-directories-first --icons --no-time $flags
    else
      ls $flags
    end
  end

  for item in $files
    if test -f "$item"
      if type -q bat
        bat -P -p $flags "$item"
      else
        cat $flags "$item"
      end

    else if test -d "$item"
      if type -q exa
        exa -l --git --group-directories-first --icons --no-time $flags "$item"
      else
        ls $flags "$item"
      end

    else
      echo "[ERR]: $item is not file or dir. don't know what to do."
    end
  end
end
