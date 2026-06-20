; Hello Protected Mode Program 
; Demonstrates the transition from real mode to protected mode with a hello message in each.
; David Wrinn

; Defines
PM_STACK_ADDRESS equ 0x90000

; real mode start routines in realmode_start.asm



[bits 32]
start_pm:
    mov ax, DATA_SEG                ; In PM, segment register values from real mode are useless.
                                    ; Initialize all the segment registers to point to the data segment offset.
    
    mov ds, ax                      ; Data segment register (default offset for data addresses).
    mov ss, ax                      ; Stack segment register (points to the segment holding the stack).
    mov es, ax                      ; General-purpose register
    mov fs, ax                      ; General-purpose register
    mov gs, ax                      ; General-purpose register

    mov ebp, PM_STACK_ADDRESS       ; Copy stack address start to base register
    mov esp, ebp                    ; Copy value to stack

    mov esi, HELLO_MSG_PM
    call print_pm_string

    jmp $



%include "asm_lib_functions/print_pm_string.asm"


; Data
HELLO_MSG_PM:
    db "Hello Protected Mode", 0x0         ; db = define byte