; Hello Real-Mode Program 
; David Wrinn

;Defines
X86_START_ADDRESS equ 0x7c00


[org X86_START_ADDRESS]         ; The BIOS loads the boot sector from disk to this address.
                                ; Therefore, we want our program entrypoint to be here.



_start:
    cli                         ; Disable interrupts
    xor ax, ax                  ; Cause ax register to be 0
    mov ds, ax                  ; Initialize segment regsiters ds, es, and ss
    mov es, ax                  
    mov ss, ax
    mov sp, X86_START_ADDRESS   ; Initialize stack pointer 
    sti                         ; Re-enable interrupts





    mov si, HELLO_MSG           ; print_string function reads characters from register si.
    call print_string           

    jmp $                       ; Hang CPU
                                ; $ = current memory address 


; Data
HELLO_MSG:
db 'Hello Real Mode', 0         ; db = define byte


%include "asm_lib_functions/print_string.asm"   ; Must be at the bottom as the assembler includes and executes it 
                                                ; right where it's placed.

; MBR Padding
times 510-($-$$) db 0       ; FOR 510 bytes - ($$ (Start Address) - $ (Current Address)) times, db 0 
dw 0xaa55                   ; x86 Magic Number. Must be the last two bytes in the 512 byte boot sector.
                            ; Without this, x86 doesn't detect the code as executable.
                            ; dw = define word

