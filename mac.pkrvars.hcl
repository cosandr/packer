qemu_efi_code    = "/opt/homebrew/share/qemu/edk2-x86_64-code.fd"
qemu_efi_vars    = "/opt/homebrew/share/qemu/edk2-i386-vars.fd"
qemu_accelerator = "tcg"
# Newer work too (like Skylake-Client) but there's warnings about unsupported instructions.
qemu_cpu_model = "Nehalem"
qemu_headless  = false
qemu_display   = "cocoa"
