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
    S1 db '+', '2', '2', 'b', '8', '6', 'X', '8'
    ls1 equ $-S1    ;ls1=8
    
    S2 db 'a', '4', '5'
    ls2 equ $-S2    ;ls2=3
    
    D times ls1+ls2 db 0    ;11* 0
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        mov edi,ls2       ; edi = len(S2)= 3
        dec edi             ; edi = poz maxima a lui S2 = 2 
        mov ecx,ls2      ; ecx = len(S2) = 3
        mov esi, 0          ; esi = pos in D = 0
        
        s2Invers:
        mov al,[S2+edi]     ; al={S2+2, S2+1, S2+0}={'5','4','a'}
        mov [D+esi], al     ; [D+0]='5', [D+1]='4', [D+2]='a'
        inc esi             ; esi={0-> 1, 2, 3}
        dec edi             ; edi={2-> 1, 0, -1}
        loop s2Invers
        
        mov edi, 1      ; edi=1        
        mov ecx, ls1  ; ecx = len(S1) = 8
        shr ecx, 1     ; ecx= ecx/2= 8/2=4
        
        loop_s1:            
        mov al, [S1+edi]    ; [S1+edi]={'2' 'b' '6' '8'}
        mov [D+esi], al     ; [D+3]='2', [D+4]='b', [D+5]='6', [D+6]='8'
        add edi, 2          ; edi={1-> 3, 5, 7, 9}
        inc esi
        loop loop_s1
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
