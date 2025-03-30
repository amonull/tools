function !! --description "allows running the last command again"
  set -l lastCmd (history | head -n 1)
  echo $lastCmd
  eval $lastCmd
end
