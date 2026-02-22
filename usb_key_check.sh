#!/bin/bash

MOUNT_POINT="/tmp/usb_check"
KEY_FILE="key_admin.bin"
KEY1="feb438dae3009275b5ef44622a58fe7f"
KEY2="71443f74a6fe26dfc75f412d56d4679d"

mkdir -p "$MOUNT_POINT" && chmod 0700 "$MOUNT_POINT"

for device in $(lsblk -lnpo NAME,RM | awk '$2==1 {print $1}'); do
    if mount -o ro,nosuid,nodev,noexec "$device" "$MOUNT_POINT" 2>/dev/null; then
        if [ -f "$MOUNT_POINT/$KEY_FILE" ] && md5sum $MOUNT_POINT/$KEY_FILE | grep -P "$KEY1|$KEY2"; then
            umount "$MOUNT_POINT"
            exit 0
        fi
        umount "$MOUNT_POINT"
    fi
done

exit 1

