# Hyprland spec files

Copied from https://github.com/sdegler/hyprlandRPM at `c0b4b329925fde640365418c88d9bd4498698184` (2026-11-16).

Changes from upstream:

- `hyprland/hyprland.spec`: from `hyprland-git/hyprland-git.spec` with `Name: hyprland` and the `%global bumpver` line removed (release tarball build instead of git snapshot). `Source5` (libxkbcommon) is only declared for Fedora < 43, where `%prep` uses it. On Fedora 43, `%prep` replaces `std::string::subview` (C++26, missing in GCC 15) in `src/ipc/s1/S1.cpp`.
- `hyprtoolkit/hyprtoolkit.spec`: removed the commented-out `Patch0` and a duplicate `BuildRequires: pkgconfig(hyprutils)`.
- `hyprland-guiutils/hyprland-guiutils.spec`: removed the commented-out Qt `BuildRequires`/`Requires` and versioned `Obsoletes: hyprland-qtutils`.

## Build generations

The playbook hashes every file in this directory. When the hash changes, it starts a new build generation (UTC timestamp) and puts it in `%dist`, e.g. `hyprutils-0.14.3-1.fc44.202611181530`. Every package then gets a new NVR and the whole chain is rebuilt in order, so dependents always link against the current libraries. No manual `Release:` bumps are needed.

## Updating

1. Edit the spec(s): change `Version:` for a new upstream release, or fix the spec.
2. Check the minimum library versions in the new Hyprland `CMakeLists.txt` (`*_MINIMUM_VERSION`) and bump those specs too.
3. Test in the VM: `TAGS=hyprland vagrant provision`.
4. Apply: `ansible-playbook converge.yml --tags hyprland`. The chain is rebuilt with mock and every package in `hyprland_local_install` is upgraded to the new generation.
5. Update the pinned commit above if changes were taken from sdegler's repo (`git log <pinned>..origin/master -- <dir>`).

Rollback: old generations stay in the local repo, so `sudo dnf downgrade <pkg>` works. Delete old result directories under `/var/cache/hyprland-rpm/repo/results/` to free space.

## Fedora release upgrade

Build for the new release before running `dnf system-upgrade`:

```bash
ansible-playbook converge.yml --tags hyprland -e hyprland_local_chroot=fedora-44-x86_64
```

The repo uses `$releasever` and `skip_if_unavailable=False`, so a missing build fails the upgrade instead of being skipped.
