# qqemu

Simple shell scripts for running QEMU virtual machines on aarch64 and riscv64 architectures.

## Requirements

- QEMU with support for target architectures:
  - `qemu-system-aarch64` for ARM64
  - `qemu-system-riscv64` for RISC-V 64-bit
- UEFI firmware for aarch64 (`edk2-aarch64` or equivalent package)
- OpenSBI firmware for riscv64 (`fw_payload.elf`)

## Usage

### aarch64

**Install from ISO:**

```sh
./aarch64/install.sh <iso_file> <qcow2_image>
```

**Run existing VM:**

```sh
./aarch64/run.sh <qcow2_image> <ssh_port>
```

### riscv64

**Install from ISO:**

```sh
./riscv64/install.sh <iso_file> <qcow2_image>
```

**Run existing VM:**

```sh
./riscv64/run.sh <qcow2_image> <ssh_port>
```

SSH into the VM using: `ssh -p <ssh_port> user@localhost`

## License
MIT
