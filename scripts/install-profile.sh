#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
conf="${LINUXTRACK_CONFIG:-$HOME/.config/linuxtrack/linuxtrack1.conf}"
profile="$repo_root/config/beamng-drive-profile.conf"
gamedata="$HOME/.config/linuxtrack/tir_firmware/gamedata.txt"

mkdir -p "$(dirname "$conf")"

if [[ -f "$conf" ]] && grep -n '^Title = BeamNG.drive$' "$conf" >/dev/null 2>&1; then
  echo "BeamNG.drive profile already exists in $conf"
else
  {
    printf '\n\n'
    cat "$profile"
    printf '\n'
  } >> "$conf"
  echo "Appended BeamNG.drive profile to $conf"
fi

if [[ -f "$gamedata" ]]; then
  echo "Found LinuxTrack game data file: $gamedata"
  echo "No BeamNG.drive NaturalPoint profile ID is added by this script yet."
else
  echo "Game data file not found yet: $gamedata" >&2
  echo "Extract game data first, then rerun this script." >&2
fi
