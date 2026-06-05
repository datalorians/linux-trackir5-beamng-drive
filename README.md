# 🏁 TrackIR 5 for BeamNG.drive Native Linux

Use a NaturalPoint TrackIR 5 camera with the **native Linux build** of
BeamNG.drive.

BeamNG.drive's Linux binary does not expose the Windows TrackIR/NaturalPoint
API. This project takes a native route instead: it reads TrackIR 5 pose data
through LinuxTrack and creates a virtual 6-axis input device that BeamNG already
knows how to bind to camera head movement.

## ✨ What This Does

- 📡 Reads yaw, pitch, and roll from a NaturalPoint TrackIR 5 through LinuxTrack.
- 🎮 Creates a virtual `SpaceMouse Pro`-compatible 6DOF input device through
  Linux `uinput`.
- 🧭 Uses BeamNG.drive's built-in absolute camera actions:
  `yawAbs`, `pitchAbs`, and `rollAbs`.
- 🎯 Supports recenter and pause helper commands, suitable for F9/F10-style
  hotkeys if you want the familiar TrackIR workflow.
- 🐧 Targets BeamNG.drive's native Linux executable.

## 🚫 What This Does Not Do

- It does not use Proton.
- It does not install or load NaturalPoint DLLs.
- It does not patch BeamNG.drive.
- It does not add steering wheel, joystick, gamepad, or vehicle controls.
- It does not require a real 3Dconnexion SpaceMouse device.

The virtual device pretends to be a `SpaceMouse Pro` because BeamNG.drive ships
a default input map for that device:

```json
{
  "name": "SpaceMouse Pro",
  "vidpid": "C62B046D",
  "bindings": [
    {"control": "rxaxis", "action": "pitchAbs"},
    {"control": "ryaxis", "action": "rollAbs"},
    {"control": "rzaxis", "action": "yawAbs", "isInverted": true}
  ]
}
```

That is the native input path this package uses.

## 📦 Requirements

- BeamNG.drive installed through Steam using the native Linux build.
- A NaturalPoint TrackIR 5 camera.
- LinuxTrack installed by this repo or already available on your system.
- Python 3.
- Python `evdev`.
- Access to `/dev/uinput`.

On Ubuntu/Mint-style systems:

```bash
sudo apt install python3-evdev
```

If your distro package is unavailable:

```bash
python3 -m pip install --user evdev
```

## 🚀 Install

Clone the repo:

```bash
git clone https://github.com/datalorians/linux-trackir5-beamng-drive.git
cd linux-trackir5-beamng-drive
```

Install LinuxTrack if you do not already have the TrackIR-capable build:

```bash
./scripts/install-linuxtrack.sh
```

Install the TrackIR profile:

```bash
./scripts/install-profile.sh
```

Install the helper commands:

```bash
./scripts/install-helpers.sh
```

Install udev access rules for the TrackIR camera and `/dev/uinput`:

```bash
./scripts/install-udev-rule.sh
```

After installing udev rules, unplug and replug the TrackIR camera. You may also
need to log out and back in once so group and device ACL changes take effect.

## ▶️ Steam Launch Option

Set this as the BeamNG.drive launch option in Steam:

```bash
$HOME/.local/bin/beamng-trackir-launch %command%
```

Launch the native Linux build of BeamNG.drive. The wrapper starts the helper,
waits for the virtual 6DOF device to exist, launches the game, and stops the
helper after the game exits.

## ✅ First Test

1. Launch BeamNG.drive from Steam with the launch option above.
2. Open `Options` → `Controls` → `Hardware`.
3. Look for a connected `SpaceMouse Pro`-compatible device.
4. Enter a vehicle and switch to a cockpit/driver camera.
5. Turn your head left/right and up/down.

If the camera does not move, open the BeamNG controls screen and confirm the
device has camera bindings for `yawAbs`, `pitchAbs`, and `rollAbs`.

## 🎛️ Tuning

You can tune the virtual head-tracker mapping with environment variables before
the `bash -lc` part of the Steam launch option.

Example:

```bash
BEAMNG_TRACKIR_YAW_DEG=60 BEAMNG_TRACKIR_PITCH_DEG=35 bash -lc '...'
```

Available settings:

| Variable | Default | Meaning |
| --- | ---: | --- |
| `BEAMNG_TRACKIR_YAW_DEG` | `180` | Real head yaw needed for full virtual yaw axis |
| `BEAMNG_TRACKIR_PITCH_DEG` | `120` | Real head pitch needed for full virtual pitch axis |
| `BEAMNG_TRACKIR_ROLL_DEG` | `120` | Real head roll needed for full virtual roll axis |
| `BEAMNG_TRACKIR_HZ` | `60` | Virtual device update rate |
| `BEAMNG_TRACKIR_INVERT_YAW` | `0` | Set to `1` to invert yaw |
| `BEAMNG_TRACKIR_INVERT_PITCH` | `0` | Set to `1` to invert pitch |
| `BEAMNG_TRACKIR_INVERT_ROLL` | `0` | Set to `1` to invert roll |
| `BEAMNG_TRACKIR_DEVICE_NAME` | `SpaceMouse Pro` | Virtual device name shown to BeamNG |
| `LINUXTRACK_LIB` | auto | Override LinuxTrack library path |

## ⌨️ Center And Pause

This package includes small commands that request center and pause behavior from
the running helper:

```bash
trackir-linux-center
trackir-linux-pause
trackir-linux-toggle
trackir-linux-resume
```

TrackIR's Windows software traditionally uses hotkeys such as F9 and F10 for
centering and pausing. Those keys are not magic inside this project; they are
just convenient defaults you can bind in your desktop environment, keyboard
software, macro pad, or Steam Input.

For example, bind:

- Center view → `$HOME/.local/bin/trackir-linux-center`
- Toggle pause → `$HOME/.local/bin/trackir-linux-toggle`

If F9/F10 conflict with BeamNG.drive or your desktop, use any keys you prefer.

## 🧯 Troubleshooting

Check whether the virtual device can be created:

```bash
$HOME/.local/bin/beamng-trackir-spacemouse
```

If you see a `/dev/uinput` permission error, install the udev rule and log out
and back in:

```bash
./scripts/install-udev-rule.sh
```

If LinuxTrack cannot find the camera, replug the TrackIR 5 and test LinuxTrack
directly:

```bash
$HOME/.local/bin/trackir-linux-pipe
```

If BeamNG sees the device but camera movement is backwards, set the relevant
invert variable in the Steam launch option.

## 🧠 AI Disclosure

This project was created with assistance from OpenAI's Codex. The hardware
testing, game-specific decisions, and validation were guided by a real Linux
user with a TrackIR 5 kit and BeamNG.drive installed locally.

## ⚖️ License

No license is currently granted. That means normal copyright restrictions apply
unless the repository owner adds a license later.
