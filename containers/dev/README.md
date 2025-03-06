# Dev
This is a personal container that i use for development, it is meant to be used along side a container manager like distrobox or toolbx.
I try to to avoid placing ides and text editors into this container and instead install them through flatpaks and attach this container onto them if an ide doesnt support it then i install it on here. On the flatpaks the env var $HOME gets changed to a different place compared to both my host and this container to avoid having them too integrated with each other.

## Image
Ubuntu:latest -> docker.io/library/ubuntu:latest

# packages

## Apt
- git
- vim
- clang
- gcc
- gdb
- nasm

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