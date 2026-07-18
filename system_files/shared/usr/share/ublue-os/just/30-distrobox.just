# vim: set ft=make :

alias distrobox := distrobox-new

# Create a new custom distrobox
distrobox-new IMAGE="prompt" NAME="prompt":
    #!/usr/bin/bash
    if [ "{{ IMAGE }}" = "prompt" ]; then
        read -rp "Image (e.g. quay.io/toolbx-images/fedora-toolbox:41): " IMAGE
    else
        IMAGE="{{ IMAGE }}"
    fi
    if [ "{{ NAME }}" = "prompt" ]; then
        read -rp "Container name: " NAME
    else
        NAME="{{ NAME }}"
    fi
    distrobox create -i "$IMAGE" -n "$NAME"
