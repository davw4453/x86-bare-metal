#!/bin/bash


# Initialize variables
REBUILD=false
DEBUG=false


# functions
clean() {
    if compgen -G "build/protectedmode/*" > /dev/null; then
        rm build/protectedmode/*
    fi
}


# parse command line arguments
while getopts "bd" opt; do
    case ${opt} in
    b )
        REBUILD=true
        ;;
    d )
        DEBUG=true
        ;;
    \?)
        echo "Usage: $0 [-b] [-d]"
        exit 1
        ;;
    esac
done


# Build raw bin file
if [[ "$REBUILD" = true && "$DEBUG" != true ]]; then
    echo "Rebuilding..."

    # Clean
    clean

    # Compile 
    nasm ProtectedMode/realmode_start.asm -f bin -o build/protectedmode/hello_pm.bin
fi

# build binary with debug symbols
if [[ "$REBUILD" = true && "$DEBUG" = true ]]; then
    echo "Building debug code..."

    # Clean
    clean

    # Compile
    nasm -f elf32 -g -F dwarf -dELF_GDB ProtectedMode/realmode_start.asm -o build/protectedmode/hello_pm.o

    # Link
    ld -m elf_i386 -Ttext 0x7c00 build/protectedmode/hello_pm.o -o build/protectedmode/hello_pm.elf #set [org 0x7c00] in the linker instead of the code

    # strip ELF for qemu launch
    objcopy -O binary build/protectedmode/hello_pm.elf build/protectedmode/hello_pm.bin
    
fi

# run in debug mode without rebuilding
if [ "$DEBUG" = true ]; then
    # Run with gdb support
    qemu-system-x86_64 -drive format=raw,file=build/protectedmode/hello_pm.bin -s -S &
    gdb -x .gdbinit
    exit
fi

# Run
qemu-system-x86_64 -drive format=raw,file=build/protectedmode/hello_pm.bin