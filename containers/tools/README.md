# TODO:
when rewriting to use with distrobox-assemble make sure u add everything here + updating /etc/makepkg.conf to have OPTIONS=(... !debug ...) so it doesnt install debug files (use regex like OPTIONS=\\\(.\*debug.\*\\\)) Also make sure `yay --devel --save` is ran once to ensure devel packages are updated everytime yay is ran to update system


# Tools
A personal container that runs most of my cli tools (or some gui tools) that i use that are not integral to my os.

## Image
docker.io/library/archlinux

## pkgs
- ani-cli
- mangal

# Why
i prefer to have a clean home folder and this allows me to achieve that it also allows me to get my apps back in a reproducible manner so i can delete them and their conf/data files if they start misbehaving and effortlessly re-install them on my machine. I also like the separation of core os apps and things that are nice to haves but not necessary in this way.
