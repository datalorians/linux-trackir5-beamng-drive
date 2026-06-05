# Notes

BeamNG.drive appears to use NaturalPoint-style TrackIR integration through
`NPClient64.dll` under Proton.

Observed strings in the local `Bin64/BeamNG.drive.x64.exe` binary:

```text
TrackIR
TrackIR: attempted to initialize twice
TrackIR not activated: No main window found
TrackIR not activated: DLL detected and loaded, but DllSignature is unexpected
TrackIR not activated: one or more functions are missing from the TrackIR DLL
TrackIR: NaturalPoint software version is {}.{}
TrackIR - start: unable to start data transmission
NP_RegisterProgramProfileID
Software\NaturalPoint\NATURALPOINT\NPClient Location
```

The BeamNG.drive launcher is in the game root:

```text
BeamNG.drive.exe
```

The main Windows game binary is:

```text
Bin64/BeamNG.drive.x64.exe
```

The installer copies the bridge into both locations and, when the Proton prefix
exists, registers `C:\linuxtrack` as the NaturalPoint client location.

The patched bridge uses:

```text
/tmp/linuxtrack_npclient_center
/tmp/linuxtrack_npclient_pause
```

The patched LinuxTrack server mirrors pause state to the TrackIR 5 status LED.
