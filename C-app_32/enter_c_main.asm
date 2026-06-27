;
; Start Execution at main().
; David Wrinn

[bits 32]
global _start
[extern main]

_start:                 ; Linker looks for this start symbol to be defined.
call main               ; use call instead of jmp for stack frame management.
jmp $                   ; If control returns from the C program, hang.