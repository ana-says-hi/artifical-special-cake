bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    A dw 10001010b
    B resw 2

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov AX, [A] ;AX=1000 1010b
        
        mov BL, AH  ;BL=AH=0
        shl BL, 4   ;BL=0
        
        mov BH, 00000000b
        
        shl AL, 6   ;AL=1000 0000
        shr AL, 6   ;AL=0000 0010
        ;im AL bleiben nur die ersten 2 bits
        
        xor BH, AL   ;BH=0000 0010b
        shl AL, 2    ;AL=0000 1000b
        xor BH, AL   ;BH=0000 1010b
        
        not BH       ;BH=1111 0101b
        
        mov EAX, 0   ;EAX=0
        mov AX, BX   ;AX=1111 0101 0000 0000b -> EAX=0000 0000 0000 0000 1111 0101 0000 0000b
        shl EAX, 16  ;EAX=1111 0101 0000 0000 0000 0000 0000 0000b
        mov AX, BX   ;EAX=1111 0101 0000 0000 1111 0101 0000 0000b
        
        mov [B],EAX  ;B=1111 0101 0000 0000 1111 0101 0000 0000b
                     ;B=F500F500
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
