if status is-login
  test -f ~/.profile && bass source ~/.profile # NOTE: bass is a plugin (https://github.com/edc/bass)
end

if status is-interactive; or status is-login
  # [ SETTING ]
  set fish_greeting               # Supresses fish's intro message
  tabs 4                          # set tab spaces to 4

  # [ KEYMAPS ]
  bind \b 'backward-kill-word'    # delete words with ctrl+backspace
  bind \e\[3\;5~ 'kill-word'      # delete words with ctrl+del

  # [ SOURCE ]
  source_dir -d ~/.aliasrc.d

  set CURR_OS (cat /etc/*-release | grep -P "^ID" | sed 's/ID=//g' | tr -d '"')
  switch $CURR_OS
    case "void"
      source_dir -d ~/.aliasrc.d/void -r
    case "fedora"
      source_dir -d ~/.aliasrc.d/fedora -r
    case '*'
      echo "OS NOT FOUND CANNOT SOURCE OS SPECIFIC ALIASES"
  end
  set -e CURR_OS

  # conf.d source order is weird and causes aliases to not work
  # functions only get sourced when called so aliases wont work unless individually created
  source_dir -d ~/.config/fish/aliasrc.d -r

  # [ SCRIPTS TO START ON TERMINAL BOOT ]
  #pokemon-colorscripts --no-title -r # -b
  #task ls

  # [ PROMPT ]
  starship init fish | source
end
