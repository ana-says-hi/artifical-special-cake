bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf , scanf            ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import scanf msvcrt.dll
import printf msvcrt.dll
                          
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    
    a dd 0
    b dd 0
    format1 db "%x", 0  ; format1 ist  hexa
  
    c resw 2
    formatC db "%d", 0  ;c ist in Basis 10
    
    msgA db "a(16)= ", 0
    msgB db "b(16)= ", 0
    msgC db "a+b in Basis 10 ist "
    
    ;Lese zwei Zahlen a und b (in der Basis 16) von der Tastatur und berechne a+b. Zeige das Ergebniss in Basis 10 an.

; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword msgA
        call [printf]
        add esp, 4
        
        push dword a
        push dword format1
        call [scanf]    ; liest a   zB 10h
        add esp, 4*2    ; stack frei
        
        push dword msgB
        call [printf]
        add esp, 4
        
        push dword b
        push dword format1
        call [scanf]    ; liest b   zB 6h
        add esp, 4*2    ; stack frei
        
        mov eax, [a]      ;eax= a
        add eax, [b]      ;eax= a+b
        mov [c], eax      ;c = a+b = 10h+6h = 16h = 22
        
        push dword msgC
        call [printf]
        add esp, 4
        
        push dword [c]
        push dword formatC  ; c ist in Basis 10
        call [printf]
        
        add esp, 4
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
