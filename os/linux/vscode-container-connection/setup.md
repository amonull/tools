# Vscode setup
These instructions are a copy of [distrobox useful tips](https://github.com/89luca89/distrobox/blob/main/docs/posts/integrate_vscode_distrobox.md) check on there for updated instructions.

1- Install [Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) plugin by microsoft

2- Put [script]() below into $HOME/.local/bin/podman-host
<details>
```bash
#!/bin/sh

id="$(echo "$@" | grep -Eo ' [a-zA-Z0-9]{64} ' | tr -d ' ')"
PODMAN_COMMAND="$(command -v podman 2> /dev/null)"
ENV_COMMAND="printenv"

# if we're in a flatpak, we fallback to host-spawn
if [ -n "${FLATPAK_ID}" ]; then
	PODMAN_COMMAND="flatpak-spawn --host podman"
	ENV_COMMAND="flatpak-spawn --host printenv"
fi

# This little workaround is used to ensure
# we use our distrobox to properly enter the container
if echo "$@" | grep -q 'exec'; then
	# we do this procedure only for distroboxes
	# we will leave regular containers alone.
	if [ "$(${PODMAN_COMMAND} inspect --type container --format '{{ index .Config.Labels "manager" }}' "${id}")" = "distrobox" ]; then

		# Ensure that our distrobox containers will use different vscode-servers
		# by symlinking to different paths
		# This is necessary because vscode-server will always use $HOME/.vscode-server
		# so we're forced to do this workaround
		if [ -n "${id}" ]; then
			# shellcheck disable=SC2016
			${PODMAN_COMMAND} exec -u "${USER}" "${id}" /bin/sh -c '
			if [ ! -L "${HOME}/.vscode-server" ]; then
				[ -e "${HOME}/.vscode-server" ] && mv "${HOME}/.vscode-server" /var/tmp
				[ -d /var/tmp/.vscode-server ] || mkdir /var/tmp/.vscode-server
				ln -sf /var/tmp/.vscode-server "$HOME"
			elif [ ! -e "${HOME}/.vscode-server" ]; then
				mkdir /var/tmp/.vscode-server
				ln -sf /var/tmp/.vscode-server "$HOME"
			fi
		'
		fi

		for i; do
			# interject root:root, we want to be our own user
			if echo "${i}" | grep -q "root:root"; then
				set -- "$@" "${USER}:${USER}"
				shift
			# inject host's environment
			elif echo "${i}" | grep -q "exec"; then
				set -- "$@" "exec"
				shift
				# inject host's environment
				for j in $(${ENV_COMMAND} | grep '=' | grep -Ev ' |"|`|\$' |
					# refer to distrobox-enter:L454
					grep -Ev '^(CONTAINER_ID|HOST|HOSTNAME|HOME|PATH|PROFILEREAD|SHELL|XDG_SEAT|XDG_VTNR|XDG_.*_DIRS|^_)'); do

					set -- "$@" "--env"
					set -- "$@" "${j}"
				done
			else
				set -- "$@" "${i}"
				shift
			fi
		done
	fi
fi

${PODMAN_COMMAND} "$@"
```
</details>

3- Change docker path to use that podman script

4- Enable podman.socket

## Enabling podman.socket
```bash
systemctl --user enable podman.socket
systemctl --user start podman.socket
```