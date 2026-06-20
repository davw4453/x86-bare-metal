;
; A function for printing the null-terminated string starting at the address stored in B register.
; David Wrinn

print_string:
    pusha
    mov ah, 0xe         ; Set BIOS interrupt 0x10 to teletype mode.

read_character:
    lodsb               ; Loads si register into al, then increments si by 1 automatically.

    cmp al, 0           ; Check if this character is null, which indicates end of string.
    je done             ; If 0 ('\0'), we've reached the end of the string.

print_character:  
    int 0x10            ; BIOS interrupt 0x10 prints ASCII character for byte in `al`.
    jmp read_character

done:
    popa
    ret

