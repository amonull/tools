#!/usr/bin/fish

function _source_files
  if test -d "$(pwd)/.git";
    set -g -x PROJ_ROOT "$(pwd)" # set and export var
  end
end

function _unsource_files
  if test -d "$(pwd)/.git";
    set -u PROJ_ROOT # unset and unexport var
  end
end

function _run_cd_cmd
  if string match -q '*..*' "$argv";
    _unsource_files
  end

  builtin cd $argv # cd into dir

  _source_files
end

function cd-wrapper --wraps cd --description "A wrapper to the builtin cd command to change directories and to have variables to change directories into"
  set -l programming_cd_path "$HOME/Documents/Programming"

  # fish currently doesnt have a way to exit with error
  if test (count $argv) -lt 1
    _unsource_files
    _run_cd_cmd "$HOME"
    return 0
  end

  if test (count $argv) -gt 1
    echo "too many arguments for cd"
    return 1
  end

  # uses alternative path for fish
  if [ $argv = fish ]
    _run_cd_cmd "$__fish_config_dir"
    return 0
  end

  # if name matches dir name just add here and if check will take care of it
  if contains "$programming_cd_path/$argv" $programming_cd_path/*
    _run_cd_cmd "$programming_cd_path/$argv"
    return 0
  end

  # alternative names or paths should be added here
  switch $argv
    case C
      _run_cd_cmd "$programming_cd_path/c++/"
      return 0

  case cpp
      _run_cd_cmd "$programming_cd_path/c++/"
      return 0

    case py
      _run_cd_cmd "$programming_cd_path/python/"
      return 0

    case Arduino
      _run_cd_cmd "$programming_cd_path/arduino/"
      return 0

    case asm
      _run_cd_cmd "$programming_cd_path/assembly/"
      return 0

    case wm
      _run_cd_cmd "/home/amon/Public/wm_shared/"
      return 0
  end

  # if nothing else matches falls here as regular cd
  _run_cd_cmd $argv
end
