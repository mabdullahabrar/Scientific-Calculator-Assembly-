INCLUDE Irvine32.inc

.data
    titleLine db "===========================", 0
    msg_intro db "         CALCULATOR     ", 0dh, 0ah
              db "===========================", 0dh, 0ah
              db "  1. Addition", 0dh, 0ah
              db "  2. Subtraction", 0dh, 0ah
              db "  3. Multiplication", 0dh, 0ah
              db "  4. Division", 0dh, 0ah
              db "  5. Negation", 0dh, 0ah
              db "  6. Square", 0dh, 0ah
              db "  7. Cube", 0dh, 0ah
              db "  8. OR", 0dh, 0ah
              db "  9. AND", 0dh, 0ah
              db " 10. XOR", 0dh, 0ah
              db " 11. NOT", 0dh, 0ah
              db " 12. Modulus", 0dh, 0ah
              db "  0. EXIT", 0

    msg_A db "=> The SUM of two Numbers = ", 0
    msg_S db "=> The SUBTRACTION of two Numbers = ", 0
    msg_M db "=> The MULTIPLICATION of two Numbers = ", 0
    msg_D db "=> The DIVISION of two Numbers = ", 0
    msg_N db "=> The NEGATIVE value of Number = ", 0
    msg_SQ db "=> The SQUARE of Number = ", 0
    msg_CB db "=> The CUBE of Number = ", 0
    msg_OR db "=> The OR of two Numbers = ", 0
    msg_AND db "=> The AND of two Numbers = ", 0
    msg_XOR db "=> The XOR of two Numbers = ", 0
    msg_NOT db "=> The NOT of Number = ", 0
    msg_MD db "=> The MODULUS of two Numbers = ", 0

    cont db "Use Again? (1 = Yes / 0 = No): ", 0
    bye1 db "===========================", 0
    bye2 db "     Thank You!!! :)     ", 0

    error_msg db "!! Cannot divide by 0. Undefined Math Error !!", 0
    enter1 db "Enter First Number: ", 0
    enter2 db "Enter Second Number: ", 0
    enter3 db "Enter a number: ", 0
    choose_op db "Choose an operation (0-12): ", 0
    invalid_msg db "!! Invalid entry. Please enter a number between 0 and 12. !!", 0
    blank_input_msg db "!! Please enter a number. Don't leave it blank. !!", 0

    heading_add db "===== ADDITION =====", 0
    heading_sub db "===== SUBTRACTION =====", 0
    heading_mul db "===== MULTIPLICATION =====", 0
    heading_div db "===== DIVISION =====", 0
    heading_neg db "===== NEGATION =====", 0
    heading_sq db "===== SQUARE =====", 0
    heading_cb db "===== CUBE =====", 0
    heading_or db "===== OR =====", 0
    heading_and db "===== AND =====", 0
    heading_xor db "===== XOR =====", 0
    heading_not db "===== NOT =====", 0
    heading_mod db "===== MODULUS =====", 0

    val1 dw ?
    val2 dw ?
    res dw ?
    agn dw ?
    input_buffer db 16 dup(0)

.code
main PROC
Start:
    call Clrscr
    call PrintHeader

GetInput:
    mov edx, OFFSET choose_op
    call WriteString
    
    ; Read input as string first
    mov edx, OFFSET input_buffer
    mov ecx, SIZEOF input_buffer
    call ReadString
    test eax, eax               ; Check if any characters were read
    jz BlankInput               ; If zero characters were read
    
    ; Convert string to integer
    mov edx, OFFSET input_buffer
    call ParseInteger32         ; Convert to integer in EAX
    jc InvalidInput             ; If conversion failed (contains non-digits)
    
    mov cx, ax
    cmp cx, 0
    jl InvalidInput
    cmp cx, 12
    jg InvalidInput

    cmp cx, 0
    je _Bye
    cmp cx, 1
    je Addition
    cmp cx, 2
    je Subtraction
    cmp cx, 3
    je Multiplication
    cmp cx, 4
    je Division
    cmp cx, 5
    je Negation
    cmp cx, 6
    je Square
    cmp cx, 7
    je Cube
    cmp cx, 8
    je _OR
    cmp cx, 9
    je _AND
    cmp cx, 10
    je _XOR
    cmp cx, 11
    je _NOT
    cmp cx, 12
    je Modulus

BlankInput:
    call Crlf
    mov edx, OFFSET blank_input_msg
    call WriteString
    call Crlf
    call WaitMsg
    jmp Start

InvalidInput:
    call Crlf
    mov edx, OFFSET invalid_msg
    call WriteString
    call Crlf
    call WaitMsg
    jmp Start

Addition:
    call OperationHeader
    mov edx, OFFSET heading_add
    call WriteString
    call Crlf
    mov edx, OFFSET enter1
    call WriteString
    call ReadInt
    mov val1, ax
    mov edx, OFFSET enter2
    call WriteString
    call ReadInt
    mov val2, ax
    mov ax, val1
    add ax, val2
    mov res, ax
    call Crlf
    mov edx, OFFSET msg_A
    call WriteString
    movsx eax, res
    call WriteInt
    jmp Con

Subtraction:
    call OperationHeader
    mov edx, OFFSET heading_sub
    call WriteString
    call Crlf
    mov edx, OFFSET enter1
    call WriteString
    call ReadInt
    mov val1, ax
    mov edx, OFFSET enter2
    call WriteString
    call ReadInt
    mov val2, ax
    mov ax, val1
    sub ax, val2
    mov res, ax
    call Crlf
    mov edx, OFFSET msg_S
    call WriteString
    movsx eax, res
    call WriteInt
    jmp Con

Multiplication:
    call OperationHeader
    mov edx, OFFSET heading_mul
    call WriteString
    call Crlf
    mov edx, OFFSET enter1
    call WriteString
    call ReadInt
    mov val1, ax
    mov edx, OFFSET enter2
    call WriteString
    call ReadInt
    mov val2, ax
    mov ax, val1
    imul val2
    mov res, ax
    call Crlf
    mov edx, OFFSET msg_M
    call WriteString
    movsx eax, res
    call WriteInt
    jmp Con

Division:
    call OperationHeader
    mov edx, OFFSET heading_div
    call WriteString
    call Crlf
    mov edx, OFFSET enter1
    call WriteString
    call ReadInt
    mov val1, ax
    mov edx, OFFSET enter2
    call WriteString
    call ReadInt
    mov val2, ax
    cmp val2, 0
    je Error
    mov dx, 0
    mov ax, val1
    cwd
    idiv val2
    mov res, ax
    call Crlf
    mov edx, OFFSET msg_D
    call WriteString
    movsx eax, res
    call WriteInt
    jmp Con

Negation:
    call OperationHeader
    mov edx, OFFSET heading_neg
    call WriteString
    call Crlf
    mov edx, OFFSET enter3
    call WriteString
    call ReadInt
    mov val1, ax
    neg ax
    mov res, ax
    call Crlf
    mov edx, OFFSET msg_N
    call WriteString
    movsx eax, res
    call WriteInt
    jmp Con

Square:
    call OperationHeader
    mov edx, OFFSET heading_sq
    call WriteString
    call Crlf
    mov edx, OFFSET enter3
    call WriteString
    call ReadInt
    mov val1, ax
    imul ax
    mov res, ax
    call Crlf
    mov edx, OFFSET msg_SQ
    call WriteString
    movsx eax, res
    call WriteInt
    jmp Con

Cube:
    call OperationHeader
    mov edx, OFFSET heading_cb
    call WriteString
    call Crlf
    mov edx, OFFSET enter3
    call WriteString
    call ReadInt
    mov val1, ax
    imul val1
    imul val1
    mov res, ax
    call Crlf
    mov edx, OFFSET msg_CB
    call WriteString
    movsx eax, res
    call WriteInt
    jmp Con

Modulus:
    call OperationHeader
    mov edx, OFFSET heading_mod
    call WriteString
    call Crlf
    mov edx, OFFSET enter1
    call WriteString
    call ReadInt
    mov val1, ax
    mov edx, OFFSET enter2
    call WriteString
    call ReadInt
    mov val2, ax
    cmp val2, 0
    je Error
    mov dx, 0
    mov ax, val1
    cwd
    idiv val2
    mov res, dx
    call Crlf
    mov edx, OFFSET msg_MD
    call WriteString
    movsx eax, res
    call WriteInt
    jmp Con

_OR:
    call OperationHeader
    mov edx, OFFSET heading_or
    call WriteString
    call Crlf
    mov edx, OFFSET enter1
    call WriteString
    call ReadInt
    mov val1, ax
    mov edx, OFFSET enter2
    call WriteString
    call ReadInt
    mov val2, ax
    mov ax, val1
    or ax, val2
    mov res, ax
    call Crlf
    mov edx, OFFSET msg_OR
    call WriteString
    movsx eax, res
    call WriteInt
    jmp Con

_AND:
    call OperationHeader
    mov edx, OFFSET heading_and
    call WriteString
    call Crlf
    mov edx, OFFSET enter1
    call WriteString
    call ReadInt
    mov val1, ax
    mov edx, OFFSET enter2
    call WriteString
    call ReadInt
    mov val2, ax
    mov ax, val1
    and ax, val2
    mov res, ax
    call Crlf
    mov edx, OFFSET msg_AND
    call WriteString
    movsx eax, res
    call WriteInt
    jmp Con

_XOR:
    call OperationHeader
    mov edx, OFFSET heading_xor
    call WriteString
    call Crlf
    mov edx, OFFSET enter1
    call WriteString
    call ReadInt
    mov val1, ax
    mov edx, OFFSET enter2
    call WriteString
    call ReadInt
    mov val2, ax
    mov ax, val1
    xor ax, val2
    mov res, ax
    call Crlf
    mov edx, OFFSET msg_XOR
    call WriteString
    movsx eax, res
    call WriteInt
    jmp Con

_NOT:
    call OperationHeader
    mov edx, OFFSET heading_not
    call WriteString
    call Crlf
    mov edx, OFFSET enter3
    call WriteString
    call ReadInt
    mov val1, ax
    not ax
    mov res, ax
    call Crlf
    mov edx, OFFSET msg_NOT
    call WriteString
    movsx eax, res
    call WriteInt
    jmp Con

Error:
    call Crlf
    mov edx, OFFSET error_msg
    call WriteString
    call Crlf
    jmp Con

Con:
    call Crlf
    mov edx, OFFSET cont
    call WriteString
    call ReadInt
    mov agn, ax
    cmp agn, 1
    je Start
    cmp agn, 0
    je _Bye

_Bye:
    call Clrscr
    call PrintFooter
    exit
main ENDP

PrintHeader PROC
    mov eax, yellow
    call SetTextColor
    mov edx, OFFSET titleLine
    call WriteString
    call Crlf
    mov edx, OFFSET msg_intro
    call WriteString
    call Crlf
    ret
PrintHeader ENDP

OperationHeader PROC
    call Clrscr
    mov eax, lightGreen
    call SetTextColor
    ret
OperationHeader ENDP

PrintFooter PROC
    mov eax, lightMagenta
    call SetTextColor
    mov edx, OFFSET bye1
    call WriteString
    call Crlf
    mov edx, OFFSET bye2
    call WriteString
    call Crlf
    mov edx, OFFSET bye1
    call WriteString
    call Crlf
    ret
PrintFooter ENDP

END main