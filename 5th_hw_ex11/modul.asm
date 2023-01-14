bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global is_prim        

; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    prim resw 2
    format db "%d", 0
    msg db "   ", 0

; our code starts here
segment code use32 class=code
    is_prim:
        ; ...
        
        ; zahl ist auf stack    ; zB 4
         
        mov edx, 0
        mov ebx, 2
        
        while1:
        mov eax, [esp+4]  ;zahl in eax, eax=4
        cmp ebx, eax
        je adev

        cmp eax, 1
        je final
        
        cmp eax, 0
        je final
    
       ; push eax    ;zahl auf Stack
        div ebx     ; 4/2= 2 edx->r=0
        cmp edx, 0   ; equal
        je final
    
        ;push eax  
        mov edx, 0
        inc ebx       
        jmp while1
        
        adev:
        mov eax, dword [esp+4]
        mov [prim], eax
        push dword [prim]
        push dword format 
        call [printf]   ;fur 4 schreibt nichts
        add esp, 8
        push dword msg
        call [printf]
        add esp, 4
        
       
        final:
        
        ; exit(0)
        ret