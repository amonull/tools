# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# History
export HISTCONTROL=ignoredups:erasedups           # no duplicate entries
HISTSIZE=1000
HISTFILESIZE=2000

# Shopt
shopt -s histappend # do not overwrite history
shopt -s cmdhist # save multi-line commands in history as single line
shopt -s cdspell # autocorrects cd misspellings

#ignore upper and lowercase when TAB completion
bind "set completion-ignore-case on"

# [ FUNCTIONS ]
source_dir() {
	local dir="$1"
	local recurse="$2"
	if [ -d "$dir" ]; then
		for file in $dir/*; do
			if [ -f "$file" ]; then
				. "$file"
				continue
			fi

			if [ -d "$file" ]; then
				if [ -n "$recurse" ]; then
					source_dir "$file" "$recurse"
				fi
			fi
		done
		unset file
	fi
}


# [SOURCE]
# Source generic aliases
source_dir "$HOME/.aliasrc.d"

# Souce os specific aliases
CURR_OS="$(cat /etc/*-release | grep -P "^ID" | sed 's/ID=//g' | tr -d '"')"
case "$CURR_OS" in
	"void")
		source_dir "$HOME/.aliasrc/void" "true"
		;;
	"fedora")
		source_dir "$HOME/.aliasrc/fedora" "true"
		;;
	*)
		echo "OS NOT FOUND CANNOT SOURCE OS SPECIFIC ALIASES"
		;;
esac
unset CURR_OS

# Source bash aliases and functions
source_dir "$HOME/.bashrc.d" "true"

# [ AUTOSTART ]
eval "$(starship init bash)"

