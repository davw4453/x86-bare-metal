;
; A function for printing the null-terminated string in protected mode, starting at the address stored in esi register.
; David Wrinn

VIDEO_MEMORY equ 0xb8000            ; Text-mode memory begins here.
AMBER_ON_BLACK equ 0x06              ; Character attribute value.

[bits 32]
print_pm_string:
    pushad                          ; pusha = 16-bit, pushad = 32-bit
    mov edx, VIDEO_MEMORY
    add edx, 0x5A0                  ; Move down 9 lines. 80 chars per line * 2 bytes per char = 160 * 9 lines = 1440 dec or 0x5A0 hex.

print_pm_string_loop:
    mov al, [esi]                   ; Point to the beginning of the string in al
    mov ah, AMBER_ON_BLACK          ; Put character attribute into ah
    cmp al, 0                       ; Check for null terminator ('\0')
    je print_done

    mov [edx], ax                   ; write high and low byte of character (ah and al) to VGA memory in a 16-bit operation.

    add esi, 0x1                    ; Increment string pointer.
    add edx, 0x2                    ; Increment VGA memory.
    jmp print_pm_string_loop

print_done:
    popad
    ret

print_char_test:
    pusha
    mov edx, 0xb8000
    mov byte [edi], 'X'
    mov byte [edi+1], 0x0f
    ret