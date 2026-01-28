#!/bin/bash

set -e


ISO_PATH="$1"
QCOW2_IMAGE="$2"


qemu-img create -f qcow2 "$QCOW2_IMAGE" 8G
qemu-system-riscv64 \
    -cpu rv64 -smp cores=4 \
    -nographic \
    -M virt -m 4096 \
    -bios fw_payload.elf \
    -drive if=none,format=raw,file="$ISO_PATH",id=cd0,readonly=on \
    -device virtio-blk-device,drive=cd0 \
    -drive if=none,format=qcow2,file="$QCOW2_IMAGE",id=hd0 \
    -device virtio-blk-device,drive=hd0 \
    -netdev user,id=net0 \
    -device virtio-net-device,netdev=net0 \
    -rtc base=utc,clock=host
