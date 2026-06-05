# Native BeamNG.drive Notes

BeamNG.drive app id: `284160`.

The user's Steam logs show the native Linux executable is being launched:

```text
BeamNG.drive/BinLinux/BeamNG.drive.x64
```

The native binary includes OpenXR support and BeamNG's regular input system, but
it does not expose the Windows TrackIR/NaturalPoint API. The native-friendly
path is therefore to provide head pose through an input device BeamNG already
binds to camera movement.

BeamNG ships a `SpaceMouse Pro` input map at:

```text
settings/inputmaps/c62b046d.json
```

That map binds:

- `rzaxis` → `yawAbs`
- `rxaxis` → `pitchAbs`
- `ryaxis` → `rollAbs`
- `xaxis` / `yaxis` / `zaxis` → translation camera axes

The helper in this repo creates a virtual uinput device using vendor/product
`046d:c62b`, then feeds TrackIR yaw, pitch, and roll into those axes.
