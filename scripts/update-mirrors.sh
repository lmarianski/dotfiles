#!/bin/bash

sudo reflector --verbose --sort rate -c PL -c DE -c GB -p https -l 5 -a 12 --save /etc/pacman.d/mirrorlist



yay -Syyuu
