# Toolchain Definitions
AS          		= nasm
CC          		= x86_64-elf-gcc
LD          		= x86_64-elf-ld
OBJCOPY     		= x86_64-elf-objcopy
QEMU        		= qemu-system-x86_64

# Directory Definitions
BUILD_DIR32   		= build/32-bit_c
C_SRC_DIR   		= C-app_32
ASM_SRC_DIR 		= C-app_32

# Define memory offsetts
BOOT_BEGIN 			= 0x7c00	#x86 loads the MBR boot sector at this address.
C_APP_BEGIN			= 0x7E00	# The user program entrypoint will be here.



#-----------Begin build rules----------#

all: release32 					# all rule defaults to release32.


release32: clean
	@echo "---> Building 32-bit Release..."
	$(AS) $(ASM_SRC_DIR)/boot.asm -f bin -o $(BUILD_DIR32)/boot.bin					# Assemble the bootloader into a flat binary.

	$(AS) $(ASM_SRC_DIR)/enter_c_main.asm -f elf32 -o $(BUILD_DIR32)/enter_c_main.o	# Assemble entrypoint stub into elf format.
	$(CC) -m32 -O0 -ffreestanding -c $(C_SRC_DIR)/main.c -o $(BUILD_DIR32)/main.o		# Compile the user app into elf format, no optimization.
	$(LD) -melf_i386 -o $(BUILD_DIR32)/main.bin -Ttext $(C_APP_BEGIN) \
		--oformat binary $(BUILD_DIR32)/enter_c_main.o $(BUILD_DIR32)/main.o		# Link them together.
	
	@cat $(BUILD_DIR32)/boot.bin $(BUILD_DIR32)/main.bin > $(BUILD_DIR32)/image32.bin	# stitch the two images together.


# Builds the bootloader without the application code.
boot32: clean
	@echo "---> Building 32-bit bootloader only..."
	$(AS) $(ASM_SRC_DIR)/boot.asm -f bin -dBOOTONLY -o $(BUILD_DIR32)/boot.bin				# Assemble the bootloader into a flat binary.
	@dd if=/dev/zero of=build/32-bit_c/sector_zero.bin bs=512 count=1						#Create a 512 byte sector of zero to take the place of the
																							# application code
	@cat $(BUILD_DIR32)/boot.bin $(BUILD_DIR32)/sector_zero.bin > $(BUILD_DIR32)/image.bin	# stitch the two images together.

run32:
	$(QEMU) -drive format=raw,file=$(BUILD_DIR32)/image32.bin -nic none

debug32: clean
	@echo "---> Building 32-bit Debug..."
	$(AS) $(ASM_SRC_DIR)/boot.asm -f elf32 -g -F dwarf -dELF_GDB -o $(BUILD_DIR32)/boot.o	# Assemble bootloader into elf format.
																							# include gdb debug symbols.

	$(AS) $(ASM_SRC_DIR)/enter_c_main.asm -f elf32 -g -F dwarf -dELF_GDB -o $(BUILD_DIR32)/enter_c_main.o	# Assemble entrypoint stub into elf format.
	$(CC) -m32 -O0 -ffreestanding -g -c $(C_SRC_DIR)/main.c -o $(BUILD_DIR32)/main.o							# Compile main.c with debug symbols, no optimization.

	# Link them all together.
	$(LD) -melf_i386 -Ttext $(BOOT_BEGIN) \
		$(BUILD_DIR32)/boot.o \
		$(BUILD_DIR32)/enter_c_main.o \
		$(BUILD_DIR32)/main.o \
		-o $(BUILD_DIR32)/image32.elf

	$(OBJCOPY) -O binary $(BUILD_DIR32)/image32.elf $(BUILD_DIR32)/image32.bin								# strip to bin for Qemu.

debug-run32:
	$(QEMU) -drive format=raw,file=$(BUILD_DIR32)/image32.bin -s -S -nic none &
	konsole -e gdb -x .gdbinit2
	


clean: 
	@rm -f $(BUILD_DIR32)/*.o
	@rm -f $(BUILD_DIR32)/*.bin
	@rm -f $(BUILD_DIR32)/*.elf



.PHONY: all release32 debug32 boot32 run32 clean