#!/bin/bash

restic --verbose --exclude-file=/home/gabriel/Dotfiles/backups/hd/exclusions.txt backup /run/media/gabriel/Geral
