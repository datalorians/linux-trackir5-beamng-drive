#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
beamng_user_dir="${BEAMNG_USER_DIR:-$HOME/.local/share/BeamNG/BeamNG.drive/current}"
target="$beamng_user_dir/mods/unpacked/beamng_trackir_input"

mkdir -p "$target"
rm -rf "$target/scripts" "$target/lua"
cp -a "$repo_root/beamng_mod/scripts" "$target/"
cp -a "$repo_root/beamng_mod/lua" "$target/"

echo "Installed BeamNG TrackIR input mod to $target"
