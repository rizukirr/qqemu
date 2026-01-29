#!/bin/sh

set -e

QCOW2_IMAGE="$1"
SSH_PORT="$2"

# Check if the user provided enough arguments
if [ -z "$QCOW2_IMAGE" ] || [ -z "$SSH_PORT" ]; then
    echo "Usage: $0 <qcow2_image> <ssh_port>"
    exit 1
fi

set -x

# https://dev.alpinelinux.org/~mps/riscv64/fw_payload.elf

qemu-system-riscv64 \
    -nographic \
    -cpu rv64 -smp cores=4 \
    -M virt -m 4096 \
    -bios fw_payload.elf \
    -drive if=none,format=qcow2,file="$QCOW2_IMAGE",id=hd0 \
    -device virtio-blk-device,drive=hd0 \
    -netdev user,id=net0,hostfwd=tcp::"$SSH_PORT"-:22 \
    -device virtio-net-device,netdev=net0 \
    -serial mon:stdio \
    -rtc base=utc,clock=host
