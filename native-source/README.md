# Vyrcord Android native source

This directory contains the Vyrcord source changes as a checksummed compressed patch against a pinned Endcord Mobile commit. Run `bash native-source/restore.sh` in a fresh checkout to materialize the Android installer, loader and mod bundle. The release workflow restores the same source before building.

The installer and runtime bundle check signed releases from `vyrcord/android`. For signing and local build instructions, see `android/README.md` after restoring the source.
