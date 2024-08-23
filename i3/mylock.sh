#!/bin/bash

# all credit and glory for this awesome script to
# github.com/savoca
# reddit.com/u/wontonspecial
#
# https://github.com/savoca/dotfiles/blob/dark/.bin/scripts/lock.sh
# https://www.reddit.com/r/unixporn/comments/3358vu/i3lock_unixpornworthy_lock_screen/

scrot -b /tmp/screen.png
convert /tmp/screen.png -blur 20x10 /tmp/screen-lock.png
rm /tmp/screen.png
#[[ -f $icon ]] && convert $tmpbg $icon -gravity center -composite -matte $tmpbg
#dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop

# Pause and unpause dunst. From the manual dunst(1):
#for x in `amixer controls  | grep layback` ; do amixer cset "${x}" on ; done

# When paused dunst will not display any notifications but keep all notifications
# in a queue.  This can for example be wrapped around a screen locker (i3lock, slock)
# to prevent flickering of notifications through the lock and
# to read all missed notifications after returning to the computer.
killall -SIGUSR1 dunst
i3lock --nofork -i /tmp/screen-lock.png
killall -SIGUSR2 dunst
rm /tmp/screen-lock.png
#for x in `amixer controls  | grep layback` ; do amixer cset "${x}" 85% ; done