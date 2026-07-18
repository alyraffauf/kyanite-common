# vim: set ft=make :
#######################
### sysexts.just
#######################

# Install a sysext (downloads transfer config, fetches latest version, merges into /usr)
[group('Extensions')]
install-sysext NAME:
    #!/usr/bin/env bash
    set -euo pipefail

    # LTS (CentOS) sysexts are built, tagged, and scoped separately from the
    # Fedora track.
    source /etc/os-release
    if [[ "${ID}" == "centos" ]]; then
        RELEASE="sysext-lts-{{ NAME }}"
        UPDATE_DIR="/var/lib/sysupdate/{{ NAME }}-lts"
        SYSEXT="/usr/bin/systemd-sysext"
    else
        RELEASE="sysext-{{ NAME }}"
        UPDATE_DIR="/var/lib/sysupdate/{{ NAME }}"
        SYSEXT="systemd-sysext"
    fi

    BASE="https://github.com/alyraffauf/kyanite-sysexts/releases/download/${RELEASE}"
    TMP=$(mktemp -d)
    trap 'rm -rf "$TMP"' EXIT

    curl -fSL "$BASE/SHA256SUMS" -o "$TMP/SHA256SUMS"
    curl -fSL "$BASE/{{ NAME }}.transfer" -o "$TMP/{{ NAME }}.transfer"
    (cd "$TMP" && sha256sum -c --ignore-missing SHA256SUMS)

    sudo install -D -m 0644 "$TMP/{{ NAME }}.transfer" "/etc/sysupdate.d/{{ NAME }}.transfer"
    sudo systemd-tmpfiles --create kyanite-sysexts.conf
    sudo install -d -m 0755 "$UPDATE_DIR"
    sudo systemctl enable --now systemd-sysupdate.timer
    sudo /usr/lib/systemd/systemd-sysupdate update
    sudo "$SYSEXT" refresh
    sudo systemd-sysusers
    sudo udevadm control --reload && sudo udevadm trigger
    echo "{{ NAME }} sysext installed and merged."

# Pull newer versions of all installed sysexts
[group('Extensions')]
update-sysexts:
    #!/usr/bin/env bash
    set -euo pipefail
    source /etc/os-release
    if [[ "${ID}" == "centos" ]]; then
        SYSEXT="/usr/bin/systemd-sysext"
    else
        SYSEXT="systemd-sysext"
    fi
    sudo /usr/lib/systemd/systemd-sysupdate update
    sudo "$SYSEXT" refresh
    sudo udevadm control --reload && sudo udevadm trigger

# Remove an installed sysext
[group('Extensions')]
remove-sysext NAME:
    #!/usr/bin/env bash
    set -euo pipefail
    source /etc/os-release
    if [[ "${ID}" == "centos" ]]; then
        UPDATE_DIR="/var/lib/sysupdate/{{ NAME }}-lts"
        SYSEXT="/usr/bin/systemd-sysext"
    else
        UPDATE_DIR="/var/lib/sysupdate/{{ NAME }}"
        SYSEXT="systemd-sysext"
    fi
    sudo rm -f "/var/lib/extensions/{{ NAME }}.raw" \
              "/etc/sysupdate.d/{{ NAME }}.transfer"
    sudo rm -rf "$UPDATE_DIR"
    sudo "$SYSEXT" refresh
    sudo udevadm control --reload && sudo udevadm trigger
    echo "{{ NAME }} sysext removed."
