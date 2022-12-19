#!/bin/sh

#
# ~/.xinitrc 
#

## Merge in defaults and user settings

# Resources; like xterm settings
sysresources=/etc/X11/xinit/.Xresources
userresources=$HOME/.Xresources

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi
#[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresource
if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

# Keymaps
sysmodmap=/etc/X11/xinit/.Xmodmap
usermodmap=$HOME/.Xmodmap

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

## Start the desktop environment
# Essentials first
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Wallpaper 
#nitrogen --set-auto ~/Pictures/Wallpapers/lorenz-84_comma.bmp

# Set the default cursor to a pointer
#xsetroot -cursor_name left_ptr

# Power Management
#xfce4-power-manager &

# Window Manager, and Status Bar
#exec xmonad

#
