#
# ~/.profile
#

# [ SOURCE SYSTEMWIDE PROFILE ]
. /etc/profile

appendpath() {
	case ":$PATH:" in
	*:"$1":*) ;;
	*)
		PATH="$1${PATH:+:$PATH}"
		;;
	esac
}

appendmanpath() {
	case ":$MANPATH:" in
	*:"$1":*) ;;
	*)
		# NOTE: needs $MANPATH: before $1 to ensure /etc/man.conf is used in manpath
		MANPATH="$MANPATH:$1"
		;;
	esac
}

### SETTING OTHER ENVIRONMENT VARIABLES
[ -z "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/.config"
[ -z "$XDG_DATA_HOME" ] && export XDG_DATA_HOME="$HOME/.local/share"
[ -z "$XDG_BIN_HOME" ] && export XDG_BIN_HOME="$HOME/.local/bin"
[ -z "$XDG_CACHE_HOME" ] && export XDG_CACHE_HOME="$HOME/.cache"

export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship/starship.toml"
# export WAYFIRE_CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/wayfire/wayfire.ini"

### FIXING JAVA SETTINGS FOR ARDUINO APP ###
# export _JAVA_AWT_WM_NONREPARENTING=1

# [USER SETTINGS]
export EDITOR="vim"
export VISUAL="code"
# export PAGER="nvimpager"
# export SYSTEMD_PAGER=

# [ PATH ]
appendpath "${XDG_BIN_HOME:-$HOME/.local/bin}"
appendpath "$HOME/.local/share/JetBrains/Toolbox/scripts"
export PATH

# [ MANPATH ]
appendmanpath "${XDG_DATA_HOME:-$HOME/.local/share}/man"
export MANPATH

