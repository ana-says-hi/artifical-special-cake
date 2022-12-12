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
    a dd 10
    b db -2
    c db 6
    d db -3
    x dq 13

; our code starts here
segment code use32 class=code
    start:
        ; ...  a-(7+x)/(b*b-c/d+2)
        mov al,[b]
        ;mov ah,[b]
        imul al     ;ax=al*al=b*b=(-2)*(-2)=4
        push ax     ; stack= [b*b=4]
        
        mov al,[c]  ; al=6
        cbw         ; al->ax=6
        mov dl,[d]  ;dl=-3
        idiv dl     ;al=ax/dl=c/d=6/(-3)=-2
        cbw     ; al->ax=-2
        
        pop bx  ;bx=b*b=4
        
        sub bx,ax   ;bx=bx-ax=b*b-c/d=4-(-2)=4+2=6
        add bx,2    ;bx=b*b-c/d+2=6+2=8
        mov ax, bx  ;ax=8
        cwde
        push eax    ;stack=[8]
        
        mov eax, dword [x+0]
        mov edx, dword [x+4]   ;edx:eax=x
        
        add eax, 7 ;eax=eax+7=x+7=13+7=20
        adc edx, 0
        
        pop ebx     ; ebx=8
        idiv ebx     ; edx:eax=(7+x)/(b*b-c/d+2)=20/8=2  rest in edx
        
        mov ebx, [a]    ; ebx=a=10
        sub ebx, eax    ; ebx=10-2=8
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
