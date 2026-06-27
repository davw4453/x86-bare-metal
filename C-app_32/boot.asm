;
; A boot sector that will load the C program from disk
; David Wrinn

;Defines
X86_START_ADDRESS equ 0x7c00
KERNEL_OFFSET equ 0x7E00                ; The beginning of the C application will be loaded here.
STACK_ADDRESS equ 0x9000

%ifndef ELF_GDB
[org X86_START_ADDRESS]                 ; Start address
%endif

%ifdef ELF_GDB
extern _start                           ; define external _start symbol if debugging.
%endif

[bits 16]
_reset:
    mov [BOOT_DRIVE], dl                    ; BIOS stores the index of the boot drive it discovered in dl.
                                            ; Store the index in the BOOT_DRIVE variable for later use.

    mov bp, STACK_ADDRESS                   ; copy the stack address value to the base pointer register.
    mov sp, bp                              ; copy to the stack pointer.

    mov si, RM_CHECKPOINT                   ; Print message indicating we are in real mode.
    call print_string                       ; Real mode printing function.
    call load_kernel
    call switch_to_pm
    jmp $                                   ; Should never be reached.

; Load the kernel into RAM in real mode.
load_kernel:
    mov si, APP_CHECKPOINT                  ; copy the c app loading message into the si register.
    call print_string

    ; To calculate the physical address:      Physical Address = (segment x 16) + offset.
    mov ax, X86_START_ADDRESS               ; Set the explicit segment register to the start address.
    shr ax, 1                               ; Shift to the right to make 0x07c0 from 0x7c00.
                                            ; Doing the calculation instead of using KERNEL_OFFSET to demonstrate the calculation.
    mov es, ax                              
    mov bx, 0x0200                          ; Offset the destination by exactly 512 bytes.
                                            ; The linker places our C code immediately after the 512 byte boot sector.
    
    mov bl, 1                               ; Put the number of sectors to read in 'bl'.
    call disk_load
    ret

; Includes
%include "asm_lib_functions/print_string.asm"
%include "asm_lib_functions/disk_load.asm"
%include "asm_lib_functions/gdt.asm"

switch_to_pm:
    cli                                     ; disable interrupts indefinitely.
    lgdt [gdt_descriptor]                   ; Load GDT.
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax                            ; PE bit enable
    jmp CODE_SEG:init_pm                    ; execute far jump
    jmp $                                   ; Never reached.

[bits 32]
init_pm:
    mov ax, DATA_SEG                        ; Initialize all the segment registers to the data segment offset in pm.
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, STACK_ADDRESS                  ; Initialize stack
    mov esp, ebp
    ; fall through to pm_start

pm_start:
    mov esi, PM_CHECKPOINT                  ; Print message indicating we are in protected mode.
    call print_pm_string

choose_entrypoint:
    %ifdef BOOTONLY                         ; Hangs here if building without the application code.
    jmp $
    %endif
    
    %ifndef ELF_GDB
    call KERNEL_OFFSET                      ; Call kernel offset at the explicit address if not building for debug.
    %endif

    %ifdef ELF_GDB
    call _start                             ; If linking everything together for debugging, call the _start symbol
    %endif

    jmp $                                   ; Never reached.


; 32-bit includes
%include "asm_lib_functions/print_pm_string.asm"

; Global variables
BOOT_DRIVE db 0x0

RM_CHECKPOINT:
    db "Real mode start", 0xa, 0xd, 0x0 ; terminate with line feed, carriage return, and null character.

PM_CHECKPOINT:
    db "Transitioned into 32-bit Protected mode", 0x0

APP_CHECKPOINT:
    db "Loading user application into memory...", 0xa, 0xd, 0x0

; Boot sector padding
times 510-($-$$) db 0x0
dw 0xaa55