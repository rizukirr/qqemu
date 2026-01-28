#!/bin/sh

set -e

QCOW2_IMAGE="$1"
SSH_PORT="$2"

# Check if the user provided enough arguments
if [ -z "$QCOW2_IMAGE" ] || [ -z "$SSH_PORT" ]; then
    echo "Usage: $0 <qcow2_image> <ssh_port>"
    exit 1
fi

# Check for UEFI firmware
DEFAULT_BIOS="/usr/share/edk2/aarch64/QEMU_EFI.fd"
BIOS_PATH=""

if [ -f "$DEFAULT_BIOS" ]; then
    BIOS_PATH="$DEFAULT_BIOS"
    echo "Using UEFI firmware: $BIOS_PATH"
else
    echo "Default UEFI firmware not found at: $DEFAULT_BIOS"
    echo -n "Enter the path to QEMU_EFI.fd (or press Enter to exit): "
    read USER_BIOS_PATH
    
    if [ -z "$USER_BIOS_PATH" ]; then
        echo "No UEFI firmware provided. Exiting."
        exit 1
    fi
    
    if [ ! -f "$USER_BIOS_PATH" ]; then
        echo "Error: File not found at $USER_BIOS_PATH"
        exit 1
    fi
    
    BIOS_PATH="$USER_BIOS_PATH"
    echo "Using UEFI firmware: $BIOS_PATH"
fi

set -x

qemu-system-aarch64 \
    -cpu cortex-a53 -smp cores=4 \
    -nographic \
    -M virt -m 4096 \
    -bios "$BIOS_PATH" \
    -drive format=qcow2,file="$QCOW2_IMAGE" \
    -device ramfb \
    -device e1000,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::"$SSH_PORT"-:22 \
    -rtc base=utc,clock=host
