# Dev
This is a personal container that i use for development, it is meant to be used along side a container manager like distrobox or toolbx.

## Image
Ubuntu:latest -> docker.io/library/ubuntu:latest

# Pre, Peri, Post
These hold scripts to run at different lifecycles of the container, the structure is simple which is just any executable file that can be ran, the number before the name indicates an order to run them with, to find all scripts to run the following script could be used (this is how it is ran inside this program): `eval $(find ./<pre,peri,post>/ -type f -executable -exec realpath {} \; | tr '\n' ';')`

## Pre
> Important: runs outside the container before the container is even made

Scripts to be ran outside of the container for general setups and preparing different things

## Peri
> Important: runs inside the container the moment it is made and is accessible

Scripts to be ran inside the container the first time it is created

## Post
> Important: runs inside the container after it has been restarted

Scripts to be ran inside the container after the container has been restarted.

# packages

## Apt
- git
- vim
- clang
- gcc
- gdb
- nasm
- yq

### dependecy
Below are packages installed as dependecies of [third-party packages or their installers](#Third-part/web installers)
- fuse
- libfuse2
- libxi6
- libxrender1
- libxtst6
- mesa-utils
- libfontconfig
- libgtk-3-bin
- tar
- dbus-user-session
- socat
- bison
- binutils
- libnss3
- libasound2-dev
- build-essential
- curl
- libffi-dev
- libffi8
- libgmp-dev
- libgmp10
- libncurses-dev
- pkg-config
- libssl-dev
- zlib1g-dev
- libbz2-dev
- libreadline-dev
- libsqlite3-dev
- libncursesw5-dev
- xz-utils
- tk-dev
- libxml2-dev
- libxmlsec1-dev
- liblzma-dev
- llvm


## Third-party/web installers
- ghcup
- rustup
- gvm
- nvm
- pyenv
- sdkman
- luaver
- perlbrew
- jetbrains-toolbox

# Usage
```bash
. ../utils/read-opts.sh
. ../utils/distrobox-utils.sh

container_name=$(getName ./info.txt)
container_home=$(getHome ./info.txt)
container_export=$(getExports ./info.txt)
container_imports=$(getImports ./info.txt)

podman build --tag "$container_name" .

sudo mkdir -p $container_home
sudo chown -R <user>:<userGroup> $container_home
mkdir -p $container_home/.local/bin

eval $(find ./pre/ -type f -executable -exec realpath {} \; | tr '\n' ';')

distrobox create --image "localhost/$container_name" --name $container_name --home $container_home

for script in $(distrobox-run-cmd "find ./peri/ -type f -executable -exec realpath {} \;"); do
    exec "$(which distrobox-enter)" --name $container_name -- 'bash' "$script"
done

distrobox stop $container_name

for script in $(distrobox-run-cmd "find ./post/ -type f -executable -exec realpath {} \;"); do
    exec "$(which distrobox-enter)" --name $container_name -- 'bash' "$script"
done

for app in $container_export; do
    distrobox-export "-b" app
done

for app in $container_imports; do
    cat <<< EOF > "$container_home/.local/bin/$app"
    #!/bin/sh
    distrobox-host-exec $app # TODO: this wont work, cant use sh vars in cat EOF str use echo to fix
    EOF
    
    chmod +x $container_home/.local/bin/$app
done

distrobox stop $container_name

echo "Setup complete to run container enter:"
echo "distrobox enter $container_name"
```

# Future Improvements
Create a yaml manifest file when either distrobox (or another container manager) supports it or if i can be asked to make a front end for it which would use [yq](https://github.com/mikefarah/yq) along side multiple bash scripts

## Yaml
```yaml
container:
    name: dev
    home: /home/.containers/dev
    export:
    - git
    - yq
    import:
    - vim
    scripts:
    # NOTE: for scripts write them into a /tmp file and then execute them using its path (it should allow for easier building and execution of vars more relaibly as they wont be handled by host sh)
        pre:
        - |
            set -e
            CONTAINER_HOME="$1"
            # setup dirs
            [ -d "$CONTAINER_HOME" ] || mkdir -p "$CONTAINER_HOME"
            mkdir -p "$CONTAINER_HOME/Documents"
            # link dirs
            ln -s "$HOME/Documents/Programming/" "$CONTAINER_HOME/Documents/Programming"
            ln -s "$HOME/.gitconfig" "$CONTAINER_HOME/.gitconfig"
            exit 0
        - echo "Pre Complete"
        peri:
        - curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 BOOTSTRAP_HASKELL_GHC_VERSION=latest BOOTSTRAP_HASKELL_CABAL_VERSION=latest BOOTSTRAP_HASKELL_INSTALL_STACK=1 BOOTSTRAP_HASKELL_INSTALL_HLS=1 BOOTSTRAP_HASKELL_ADJUST_BASHRC=A sh
        - |
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o /tmp/rustup.sh
            chmod +x /tmp/rustup.sh
            /tmp/rustup.sh -y
        - curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash
        - |
            NVM_VERSION=$(curl -s "https://github.com/nvm-sh/nvm/tags" | grep "Link--primary Link" | awk -F '</a>' '{print $1}' | awk -F '>' '{print $NF}' | head -n 1)
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash
        - |
            curl -fsSL https://pyenv.run | bash
            echo "export PYENV_ROOT=\"$HOME/.pyenv\"" >> .bashrc
            echo "[[ -d $PYENV_ROOT/bin ]] && export PATH=\"$PYENV_ROOT/bin:$PATH\"" >> .bashrc
            echo "eval \"$(pyenv init - bash)\"" >> .bashrc
        - curl -s "https://get.sdkman.io" | bash
        - |
            LUAVER_VERSION=$(curl -s "https://github.com/DhavalKapil/luaver/releases/tag/v1.1.0" | grep "Link--primary Link" | awk -F '</a>' '{print $1}' | awk -F '>' '{print $NF}' | head -n 1)
            curl -fsSL https://raw.githubusercontent.com/dhavalkapil/luaver/master/install.sh | sh -s - -r ${LUAVER_VERSION}
        - |
            curl -L https://install.perlbrew.pl | bash
            echo "source ~/perl5/perlbrew/etc/bashrc" >> ~/.bashrc
        - |
            JETBRAINS_TOOLBOX_VERSION="2.5.2.35332"
            wget -q -O- https://download.jetbrains.com/toolbox/jetbrains-toolbox-${JETBRAINS_TOOLBOX_VERSION}.tar.gz | tar -xz -C /tmp
            /tmp/jetbrains-toolbox-${JETBRAINS_TOOLBOX_VERSION}/jetbrains-toolbox &
            bg_pid=$! # get above bg process pid to kill later
            sleep 2
            pgrep $bg_pid && pkill $bg_pid
        - eval "$(curl https://get.x-cmd.com)"
        #- echo "Peri Complete"
        post:
        - |
            GO_VER=$(gvm listall | grep "go[0-9]*\.[0-9]*\.[0-9]*" | tail -n -1)
            gvm install $GO_VER -B
            gvm use $GO_VER
            nvm install --lts
            pyenv install 3
            pyenv global 3
            sdk install java
            sdk install maven
            sdk install gradle
            LUA_VER="$(luaver list -r | tail -n -1)"
            luaver install $LUA_VER
            perlbrew install --notest stable
        - echo "Post Complete"
        
image:
    Containerfile: |
        FROM docker.io/library/ubuntu:latest
        LABEL name="dev-box" \
            version="latest" \
            usage="This image is meant to be used with a container manager like distrobox or toolbx" \
            summary="Custom image load with all of my dev tools"
        COPY pkgs.txt /tmp/pkgs.txt
        RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install $(cat /tmp/pkgs.txt | xargs)

    pkgs.txt: |
        fuse
        libfuse2
        libxi6
        libxrender1
        libxtst6
        mesa-utils
        libfontconfig
        libgtk-3-bin
        tar
        dbus-user-session
        socat
        bison
        binutils
        libnss3
        libasound2-dev
        build-essential
        curl
        libffi-dev
        libffi8
        libgmp-dev
        libgmp10
        libncurses-dev
        pkg-config
        libssl-dev
        zlib1g-dev
        libbz2-dev
        libreadline-dev
        libsqlite3-dev
        libncursesw5-dev
        xz-utils
        tk-dev
        libxml2-dev
        libxmlsec1-dev
        liblzma-dev
        llvm
        git
        vim
        clang
        gcc
        gdb
        nasm
        yq
```
