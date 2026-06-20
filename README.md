# x86-bare-metal
A development environment to explore creating bare metal programs for x86; in both assembly and C.

## Project Goals
To explore low level coding at each mode in an x86 system. Finally, I will create a monitor program similar to Steve Wozniak's Wozmon built in C which runs in long mode.

1. Real mode program that prints a message.
2. Program that prints the same message in real mode then transitions into 32-bit protected mode and prints a message.
3. Create a basic 32-bit C program. Bootloader code will be in assembly and will launch the C main() entrypoint.
4. Program that transitions from real mode -> 32-bit protected mode -> 64-bit long mode. It will print the same real mode and protected mode messages as above and then print a message in long mode, programmed in assembly.
5. Create a 64-bit monitor program in C.

## Real Mode
The real mode program can be assembled and ran by executing the script 'launch_helloRealMode_qemu.sh'. Running the script with the -b flag will assemble the program into a .bin and launch it into a QEMU window. Omitting the -b flag will assume the program has been built and only launch QEMU.

## Protected Mode
The protected mode program can be assembled and ran by executing the script 'launch_helloProtectedMode_qemu.sh'. The script can be ran with two flags, -b and/or -d. -b will build the program as a raw .bin file and launch in QEMU, just as in the Real Mode program. Passing the flags -b AND -d will compile the program into an ELF, allowing it to be used with gdb. The script will then strip the elf back into a .bin, launch it with QEMU and additionally launch gdb along with it. Passing only the -d flag into the script will assume the project is already built and skip to launching QEMU and gdb immediately. Passing no flags into the script will assume the project is already built and launch QEMU without gdb.

## 32-bit C Program
TBD

## Long Mode
TBD

## 64-bit Monitor
TBD



## Credit
Referenced https://github.com/lukearend/x86-bootloader/ for theory and intialization code.
