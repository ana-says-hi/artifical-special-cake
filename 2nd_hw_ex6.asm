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
    A dw 10001000b
    B db 1001b
    C resw 2

; our code starts here
segment code use32 class=code
    start:
        ; ...
    
        MOV EAX,0   ;EAX=0
        MOV AL, [B] ;AL=0000 1001
        
        SHL EAX, 16 ;EAX=0000 0000 0000 1001 0000 0000 0000 0000 
        
        MOV AX, [A] ;AX= 1000 1000 ->EAX= 0000 0000 0000 1001 0000 0000 1000 1000 
        SHL EAX, 8  ;->EAX= 0000 1001 0000 0000 1000 1000 0000 0000
        
        MOV BL,[B]  ; BL= 0000 1001
        SHR BL, 1   ; BL= 0000 0100
        SHL BL, 6   ; BL= 0000 0000
        
        MOV AL, BL  ;AL=BL=0
       
        MOV BX, [A] ; BX=0000 0000 1000 1000
        SHL BX, 6   ; BX=0010 0010 0000 0000
        SHR BX, 12  ; BX=0000 0000 0000 0010
        
        OR AL,BL   ; AL=0000 0010
        OR AL, 00110000b    ;AL=0011 0010
        
        MOV [C], EAX    ;C=EAX= 0000 1001 0000 0000 1000 1000 0011 0010
                        ;C  =   09008832
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
