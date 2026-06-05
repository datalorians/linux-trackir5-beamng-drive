#!/usr/bin/env bash
set -euo pipefail

appid="${BEAMNG_DRIVE_APPID:-284160}"
steam_root="${STEAM_ROOT:-$HOME/.local/share/Steam}"
game_dir="${BEAMNG_DRIVE_GAME_DIR:-$steam_root/steamapps/common/BeamNG.drive}"
pfx="${BEAMNG_DRIVE_PFX:-$steam_root/steamapps/compatdata/$appid/pfx}"
prefix="${LINUXTRACK_PREFIX:-$HOME/.local/opt/linuxtrack-trackir}"
bridge="${LINUXTRACK_BRIDGE:-$prefix/wine/NPClient64.dll.so}"
bin64_dir="$game_dir/Bin64"

if [[ ! -f "$bridge" ]]; then
  echo "Bridge not found: $bridge" >&2
  echo "Run scripts/build-wine-bridge.sh first." >&2
  exit 1
fi

if [[ ! -d "$game_dir" ]]; then
  echo "BeamNG.drive game directory not found: $game_dir" >&2
  exit 1
fi

if [[ ! -d "$bin64_dir" ]]; then
  echo "BeamNG.drive Bin64 directory not found: $bin64_dir" >&2
  exit 1
fi

cp "$bridge" "$game_dir/NPClient64.dll"
cp "$bridge" "$game_dir/NPClient.dll"
cp "$bridge" "$bin64_dir/NPClient64.dll"
cp "$bridge" "$bin64_dir/NPClient.dll"

if [[ -d "$pfx" ]]; then
  mkdir -p "$pfx/drive_c/linuxtrack"
  cp "$bridge" "$pfx/drive_c/linuxtrack/NPClient64.dll"
  cp "$bridge" "$pfx/drive_c/linuxtrack/NPClient.dll"

  WINEPREFIX="$pfx" WINEDEBUG=-all wine reg add \
    'HKCU\Software\NaturalPoint\NATURALPOINT\NPClient Location' \
    /v Path /t REG_SZ /d 'C:\linuxtrack' /f
else
  echo "BeamNG.drive Proton prefix not found yet: $pfx" >&2
  echo "Launch BeamNG.drive once through Steam, then rerun this script to register C:\\linuxtrack." >&2
fi

echo "Installed NPClient bridge for BeamNG.drive."
echo "Game: $game_dir"
echo "Bin64: $bin64_dir"
echo "Prefix: $pfx"
