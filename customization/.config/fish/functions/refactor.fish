function refactor --description "Change values inside files"
  sed -i "s@$argv[1]@$argv[2]@g" $argv[3..-1]
end
