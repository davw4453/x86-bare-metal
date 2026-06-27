;
; Load `bl` sectors to `es:bx` from drive `dl`.
; David Wrinn
; Referenced: https://github.com/lukearend/x86-bootloader/

disk_load:
    pusha
    mov ah, 0x02                    ; BIOS read sector function
    mov al, bl                      ; Read the number of sectors stored in the bl register.

    mov ch, 0                       ; Select cylinder 0. 0-indexed.
    mov cl, 2                       ; Start reading from the second sctor. 1-indexed.

    mov dh, 0                       ; Select first head.
    ;The boot drive index was copied to 'dl' at the beginning of the code.

    int 0x13                        ; BIOS begin read.
    jc disk_error                   ; carry flag is set if there was a read error.

    cmp al, bl                      ; Check that the expected number of sectors were read.
    jne disk_error

    popa
    ret

disk_error:
    mov si, ERROR_MSG
    call print_string
    jmp $

ERROR_MSG:
    db "Disk read error", 0x0

