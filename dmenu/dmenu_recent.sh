#!/bin/bash

# Originally based on code by Dieter Plaetinck.
# ---
# Pretty much re-written by Mina Nagy Zaki (mnzaki on GitHub)
# https://github.com/mnzaki/dmenu-recent
# ---
# Customized by Gabriel Pedrosa.

terminal="konsole -e"
dmenu_cmd="dmenu $DMENU_OPTIONS"
max_recent=199 # Number of recent commands to track

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/dmenu-recent"
recent_cache="$cache_dir/recent"
rest_cache="$cache_dir/all"
known_types=" background terminal terminal_hold "

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/dmenu-recent"
mkdir -p "$cache_dir"
mkdir -p "$config_dir"
touch "$recent_cache"

IFS=:
if [[ ! -e "$rest_cache" ]] || stest -dqr -n "$rest_cache" $PATH 2>/dev/null; then
    stest -flx $PATH | sort -u | grep -vf "$recent_cache" > "$rest_cache"
fi

IFS=" "
cmd=$(cat "$recent_cache" "$rest_cache" | $dmenu_cmd -p Execute: "$@") || exit

if ! grep -qx "$cmd" "$recent_cache" &> /dev/null; then
    grep -vx "$cmd" "$rest_cache" > "$rest_cache.$$"
    mv "$rest_cache.$$" "$rest_cache"
fi

echo "$cmd" > "$recent_cache.$$"
grep -vx "$cmd" "$recent_cache" | head -n "$max_recent" >> "$recent_cache.$$"
mv "$recent_cache.$$"  "$recent_cache"

exec $cmd
