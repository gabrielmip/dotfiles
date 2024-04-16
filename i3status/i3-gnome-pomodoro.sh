#!/usr/bin/env bash

i3status -c ~/Dotfiles/i3status/config | while :
do
  read line
  pomodoro=`i3-gnome-pomodoro status`
  if [ -n "$pomodoro" ]; then
    echo "$pomodoro| $line" || exit 1
  else
    echo $line || exit 1
  fi
done
