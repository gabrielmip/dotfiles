#!/usr/bin/env python3
"""
Reference: https://www.reddit.com/r/i3wm/comments/sdzqn1/comment/isal5jd/

This gets information from gnome-pomodoro and playerctl and add them to
i3status initial result.
"""
import json
import subprocess
import sys


def get_pomodoro_status():
    exitcode, status = subprocess.getstatusoutput("i3-gnome-pomodoro status")
    return status if exitcode == 0 and status else None


def get_dunst_status():
    is_paused = subprocess.getoutput("dunstctl is-paused") == "true"
    return "   Dunst" if is_paused else None


def get_current_music_title():
    title = subprocess.getoutput("playerctl -i firefox,chromium metadata title")
    return None if "No players found" in title else title


def get_current_music_artist():
    artist = subprocess.getoutput("playerctl -i firefox,chromium metadata artist")
    if artist == "No player could handle this command" or not artist:
        return None
    return artist


def get_music_icon():
    status = subprocess.getoutput("playerctl -i firefox,chromium status")
    if status == "Playing":
        return "♪"
    if status == "Paused":
        return ""
    return None


def get_music_status():
    icon = get_music_icon()
    title = get_current_music_title()
    artist = get_current_music_artist()

    return (
        f"{icon} {artist} - {title}"
        if icon and title and artist
        else None
    )


def print_line(message):
    """Non-buffered printing to stdout."""
    sys.stdout.write(message + "\n")
    sys.stdout.flush()


def read_line():
    """Interrupted respecting reader for stdin."""
    # try reading a line, removing any extra whitespace
    try:
        line = sys.stdin.readline().strip()
        # i3status sends EOF, or an empty line
        if not line:
            sys.exit(3)
        return line
    # exit on ctrl-c
    except KeyboardInterrupt:
        sys.exit()


if __name__ == "__main__":
    # Skip the first line which contains the version header.
    print_line(read_line())

    # The second line contains the start of the infinite array.
    print_line(read_line())

    while True:
        line, prefix = read_line(), ""

        # ignore comma at start of lines
        if line.startswith(","):
            line, prefix = line[1:], ","
        j = json.loads(line)

        music_status = get_music_status()
        if music_status:
            j.insert(
                0,
                {
                    "full_text": music_status,
                    "name": "music_title",
                    "separator_block_width": 25,
                },
            )

        dunsct_status = get_dunst_status()
        if dunsct_status:
            j.insert(
                0,
                {
                    "full_text": dunsct_status,
                    "name": "dunst",
                    "separator_block_width": 25,
                    "color": "#e07282",
                },
            )

        pomodoro_status = get_pomodoro_status()
        if pomodoro_status:
            j.insert(
                0,
                {
                    "full_text": pomodoro_status,
                    "name": "pomodoro",
                    "separator_block_width": 25,
                },
            )

        print_line(prefix + json.dumps(j))
