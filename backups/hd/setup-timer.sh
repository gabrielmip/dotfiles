#!/bin/bash

systemctl link --user /home/gabriel/Dotfiles/backups/hd/hd-backup.timer
systemctl link --user /home/gabriel/Dotfiles/backups/hd/hd-backup.service
systemctl enable --user hd-backup.timer
systemctl start --user hd-backup.timer
systemctl --user list-timers
