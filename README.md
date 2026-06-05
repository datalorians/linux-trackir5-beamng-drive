# 🏁 TrackIR 5 for BeamNG.drive on Linux / Proton

Use a **NaturalPoint TrackIR 5** camera with **BeamNG.drive** on Linux through
Steam/Proton.

BeamNG.drive has built-in Windows TrackIR support. This package adds the Linux
side: LinuxTrack for the TrackIR 5 camera, plus a Proton-compatible
`NPClient64.dll` bridge so BeamNG.drive can talk to the hardware.

## ✨ What This Does

- Builds LinuxTrack from the maintained `exuvo/linuxtrack` fork.
- Installs TrackIR 5 USB permissions through a udev rule.
- Adds a BeamNG.drive LinuxTrack profile.
- Builds and installs a Proton-compatible `NPClient64.dll` / `NPClient.dll`.
- Installs the bridge for the BeamNG.drive launcher and `Bin64` game binary.
- Adds bridge-level recenter and pause/resume control.
- Mirrors pause state to the TrackIR 5 status LED, matching the familiar
  Windows TrackIR behavior.

## 🚫 What This Does Not Do

- It does not include NaturalPoint firmware, NaturalPoint software, or
  proprietary NaturalPoint DLLs.
- It does not add vehicle input, wheel, or force-feedback changes.
- It does not modify BeamNG.drive gameplay files or input bindings.

## ✅ Tested / Observed Setup

| Item | Value |
| --- | --- |
| Game | BeamNG.drive |
| Steam app ID | `284160` |
| TrackIR integration observed | `TrackIR`, `NPClient64.dll`, `NP_RegisterProgramProfileID`, NaturalPoint registry key, and TrackIR start/stop strings in `Bin64/BeamNG.drive.x64.exe` |
| TrackIR camera | TrackIR 5, USB ID `131d:0158` |
| Clip | TrackClip Pro |
| Proton prefix | `~/.local/share/Steam/steamapps/compatdata/284160/pfx` |
| Game directory | `~/.local/share/Steam/steamapps/common/BeamNG.drive` |
| Main game binary | `~/.local/share/Steam/steamapps/common/BeamNG.drive/Bin64/BeamNG.drive.x64.exe` |
| Desktop tested | Cinnamon/X11 |

BeamNG.drive is primarily a Windows game. BeamNG's own FAQ says Linux/Proton is
not an officially guaranteed platform, even though many users run it that way.

Important: Steam may launch BeamNG.drive's native Linux binary on Linux:

```text
~/.local/share/Steam/steamapps/common/BeamNG.drive/BinLinux/BeamNG.drive.x64
```

This package targets the Windows/Proton build because the observed
NaturalPoint/TrackIR integration is in:

```text
~/.local/share/Steam/steamapps/common/BeamNG.drive/Bin64/BeamNG.drive.x64.exe
```

## 📦 Install

Install build dependencies first. On Debian/Ubuntu-like systems:

```bash
sudo apt install git build-essential autoconf automake libtool pkg-config \
  libusb-1.0-0-dev wine-staging-dev wine mono-utils
```

Clone this repo:

```bash
git clone https://github.com/datalorians/linux-proton-trackir5-beamng-drive.git
cd linux-proton-trackir5-beamng-drive
```

Build/install LinuxTrack and install the TrackIR 5 udev rule:

```bash
./scripts/install-linuxtrack.sh
./scripts/install-udev-rule.sh
```

Replug the TrackIR camera or log out/in after installing the udev rule.

LinuxTrack still needs the firmware/game data from the official TrackIR 5
Windows installer.

Install the BeamNG.drive profile and Proton bridge:

```bash
./scripts/install-profile.sh
./scripts/build-wine-bridge.sh
./scripts/install-beamng-drive-bridge.sh
```

Install helper commands:

```bash
./scripts/install-helpers.sh
```

Optional Cinnamon/X11 shortcut installer:

```bash
./scripts/install-cinnamon-hotkeys.sh
```

## 🎮 Steam Setup

Force BeamNG.drive to use Proton:

1. Open BeamNG.drive properties in Steam.
2. Go to `Compatibility`.
3. Enable `Force the use of a specific Steam Play compatibility tool`.
4. Choose Proton Experimental or another Proton version you normally use.

BeamNG.drive should start TrackIR when it loads the installed `NPClient64.dll`.
TrackIR itself does **not** need a Steam launch option.

Launch BeamNG.drive through Steam after forcing Proton. If BeamNG.drive creates
the Proton prefix after that first Proton launch, rerun:

```bash
./scripts/install-beamng-drive-bridge.sh
```

That second run writes the NaturalPoint registry path inside the Proton prefix.
If `~/.local/share/Steam/steamapps/compatdata/284160` exists but has no `pfx`
directory, BeamNG.drive has probably launched the native Linux binary instead
of the Windows/Proton binary.

### Optional Exit Cleanup

LinuxTrack can sometimes leave its socket/lock files behind after the game
closes. If the TrackIR LEDs stay lit after BeamNG.drive exits, use this Steam
launch option so cleanup runs when the game process ends:

```text
bash -lc 'cleanup(){ "$HOME/.local/bin/trackir-linux-stop"; }; trap cleanup EXIT; "$@"; rc=$?; cleanup; exit $rc' -- %command%
```

This does not start TrackIR. BeamNG.drive still starts TrackIR by loading the
installed `NPClient64.dll`; the wrapper only runs cleanup after the game closes.

## 👀 In-Game Behavior

BeamNG.drive uses TrackIR as head tracking for supported cameras/views. The
expected feel is:

- Your existing vehicle input setup still drives the vehicle.
- TrackIR controls camera/head movement.
- Interior camera is the best first test.
- If the view feels tiny or too aggressive, tune the LinuxTrack BeamNG.drive
  profile first.

BeamNG.drive may also have camera and head-tracking settings in its Options UI.
Check those if the DLL loads but the camera does not move.

## ⌨️ Recenter and Pause Controls

The helper commands are:

```bash
trackir-linux-center
trackir-linux-toggle
trackir-linux-pause
trackir-linux-resume
```

The optional Cinnamon installer binds these to the classic TrackIR-style keys:

- `F9` for recenter
- `F10` for pause/resume

Those keys are not a special project feature; they are simply the familiar
Windows TrackIR defaults. You can bind any keys you want in your desktop
environment, keyboard utility, Stream Deck, joystick macro tool, or window
manager.

For example, bind:

```text
your preferred recenter key -> ~/.local/bin/trackir-linux-center
your preferred pause key    -> ~/.local/bin/trackir-linux-toggle
```

Pause freezes the last pose returned to the game and turns the TrackIR status
LED to the paused color. It does not shut down the camera service.

## 🧯 Troubleshooting

Debug launch option:

```bash
LINUXTRACK_DBG=w %command%
```

Possible debug log locations:

```text
~/.local/share/Steam/steamapps/common/BeamNG.drive/NPClient.log
~/.local/share/Steam/steamapps/common/BeamNG.drive/Bin64/NPClient.log
```

Rollback the installed bridge:

```bash
./scripts/rollback-bridge.sh
```

Stop leftover LinuxTrack state manually:

```bash
trackir-linux-stop
```

See [Notes](docs/notes.md) for observed bridge details and local behavior.

## 🤖 AI Disclosure

This package was developed with assistance from OpenAI's Codex/ChatGPT. The
scripts, patches, and documentation were reviewed locally before publication,
but they are community-maintained and provided as-is.

AI disclosure is separate from licensing: the disclosure explains how the work
was produced, while the license explains what rights you have to use and modify
the code.

## 📄 License

No license has been selected for this repository.

LinuxTrack has its own license. NaturalPoint firmware, software, and trademarks
belong to their respective owners and are not included in this repository.
