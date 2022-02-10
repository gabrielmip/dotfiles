#!/bin/bash

systemctl link --user /home/gabriel/Dotfiles/backups/syncthing/syncthing-backup.timer
systemctl link --user /home/gabriel/Dotfiles/backups/syncthing/syncthing-backup.service
systemctl enable --user syncthing-backup.timer
systemctl start --user syncthing-backup.timer
systemctl --user list-timers
