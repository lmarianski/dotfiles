#!/bin/bash

[ "$(id -u)" -ne 0 ] && exec sudo $0

reflector --verbose --sort rate -c PL -c DE -c GB -p ftp -p https -l 5 -a 12 --save /etc/pacman.d/mirrorlist
pacman -Syyuu
