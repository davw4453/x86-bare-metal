;
; Start Execution at main().
; David Wrinn

[bits 32]
global _start
[extern main]

_start:                 ; Linker looks for this start symbol to be defined.
call main
jmp $                   ; If control returns from the C program, hang.