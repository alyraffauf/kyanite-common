# Kyanite Common

`kyanite-common` is the shared OCI layer consumed by the Fedora Kyanite and
CentOS Stream Kyanite LTS images.

The image is an artifact container, not a bootable operating system. It
contains shared build inputs at these paths:

- `/system_files/shared` - distro-neutral filesystem overlays
- `/brew` - Homebrew manifests
- `/flatpaks` - Flatpak preinstall manifests
- `/ujust` - shared user commands
- `/build_files/shared` - shared build helpers

Downstream image builds copy these inputs into a temporary build context and
apply image-specific files afterward. The downstream repositories should pin
the common image by digest.

Build locally with:

```bash
podman build --tag localhost/kyanite-common:stable .
```
