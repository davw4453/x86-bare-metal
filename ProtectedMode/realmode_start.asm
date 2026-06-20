; X86 Real-Mode start routine
; Hands execution to Protected Mode
; David Wrinn

;Defines
X86_START_ADDRESS equ 0x7c00


%ifndef ELF_GDB
[org X86_START_ADDRESS]         ; The BIOS loads the boot sector from disk to this address.
                                ; Therefore, we want our program entrypoint to be here.
                                ; code here increments from X86_START_ADDRESS.
%endif

global _start                   ; defined for linker when compiling in debug mode.

[bits 16]
_start:
    cli                         ; Disable interrupts
    xor ax, ax                  ; Cause ax register to be 0
    mov ds, ax                  ; Initialize segment regsiters ds, es, and ss
    mov es, ax                  
    mov ss, ax
    mov sp, X86_START_ADDRESS   ; Initialize stack pointer, decrements from X86_START_ADDRESS
    sti                         ; Re-enable interrupts

    mov si, HELLO_MSG           ; print_string function reads characters from register si.
    call print_string           


 ; Begin the transition into 32-bit protected mode
switch_to_pm:
    cli                         ; Switch off interrupts until we have setup the protected-mode interrupts.
    lgdt [gdt_descriptor]       ; Load Global Descriptor Table, defining the protected-mode segments.
    
 ; Only cr0 should be used in real mode to start the transistion into protected mode.
    mov eax, cr0                ; cr0 can't be modified diretly, so move to eax temporarily.
    or eax, 0x1                 ; PE bit enable
    mov cr0, eax            

    jmp CODE_SEG:start_pm       ; Issue a far jump to a 32-bit address (flushes CPU pipeline).

    jmp $                       ; Never reached

%include "asm_lib_functions/print_string.asm"
%include "asm_lib_functions/gdt.asm"
%include "ProtectedMode/hello_protectedMode.asm"


; Data
HELLO_MSG:
db "Hello Real Mode", 0x0D, 0x0A, 0x0         ; db = define byte 
                                              ; Carriage return, line feed, null terminator at end

; MBR Padding
times 510-($-$$) db 0       ; FOR 510 bytes - ($$ (Start Address) - $ (Current Address)) times, db 0 
dw 0xaa55                   ; x86 Magic Number. Must be the last two bytes in the 512 byte boot sector.
                            ; Without this, x86 doesn't detect the code as executable.
                            ; dw = define word
