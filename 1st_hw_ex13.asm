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
    a db 6
    b dd 3
    c db 3
    d db 2
    x dq 20

; our code starts here
segment code use32 class=code
    start:
        ; ... x-(a+b+c*d)/(9-a)
        mov al, [c] ;c -> ax
        mov dh, [d] 
        mul dh  ; ax=al*dh=c*d=3*2=6
        mov bx,ax
        
        mov al, [a] ;a ist Byte in al
        mov ah, 0        ;a ist Word in ax
        add bx, ax     ; bx=ax+bx=a+(c*d)=6+6=12
    
        mov eax, 0
        mov ax, bx      ;eax=12
        add eax, [b]    ;eax=eax+b=12+3=15
        
        mov edx,eax     ;edx=eax=a+b+c*d=15
 
        mov bx, 9      ; ebx=9
        mov al,[a]     ;al=6
        mov ah,0       ;ah=0, ax=6
        sub bx,ax      ; ebx=ebx-edx=9-a=9-6=3
        
        push edx   
        pop ax  ;ax=edx=15
        pop dx  ;dx=0
        
        ;mov ax, dx  ; dx->ax ;ax=15
        ;shr edx,16  ; 16 bits nach rechts
        
        div bx  ;ax=dx:ax/bx=15/3=5, dx=ax:dx%bx
        mov cx,ax   ;cx=5
        
        mov ebx, dword [x+0]    ;die ersten Bits von rechts -> ebx=20
        mov edx, dword [x+4]    ;edx=0
        
        ;x=edx:ebx
        
        mov eax, 0  ;eax=0
        mov ax, cx  ;ax=cx=5  ->eax=5
        
        clc
        sub ebx, eax    ;ebx=ebx-eax=x-5=20-5=15, weil ebx die letzen zifferern sind
        sbb edx, 0
        
        ;die Loesung liegt im edx:ebx
        
 
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
