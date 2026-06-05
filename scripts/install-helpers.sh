#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$HOME/.local/bin"

install -m 0755 "$repo_root"/bin/trackir-linux-* "$HOME/.local/bin/"
install -m 0755 "$repo_root"/bin/beamng-trackir-spacemouse "$HOME/.local/bin/"
install -m 0755 "$repo_root"/bin/beamng-trackir-spacemouse-stop "$HOME/.local/bin/"

echo "Installed BeamNG.drive TrackIR helper commands into $HOME/.local/bin"
