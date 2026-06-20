#!/bin/bash


# Initialize variables
REBUILD=false


# parse command line arguments
while getopts "b" opt; do
    case ${opt} in
    b )
        REBUILD=true
        ;;
    \?)
        echo "Usage: $0 [-b]"
        exit 1
        ;;
    esac
done


if [ "$REBUILD" = true ]; then
    echo "Rebuilding..."

    # Clean
    if compgen -G "build/realmode/*" > /dev/null; then
        rm build/realmode/*
    fi

    # Compile 
    nasm RealMode/hello_realmode.asm -f bin -o build/realmode/hello_realmode.bin
fi

# Run
qemu-system-x86_64 -drive format=raw,file=build/realmode/hello_realmode.bin