bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fprintf, fclose               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fprintf msvcrt.dll
import fclose msvcrt.dll
                          
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    
    text db 'abcABCaA@#123a', 0
    len equ $-text
    
    file_name db "file.txt", 0
    access_mode db "w", 0
    file_descriptor dd -1
    
    ;Ein Dateiname und ein Text (definiert im Datensegment) werden gegeben. Der Text enthält Kleinbuchstaben, Großbuchstaben, Ziffern und Sonderzeichen. Wandelt alle Kleinbuchstaben aus dem angegebenen Text in Großbuchstaben um. Erstelle eine Datei mit dem angegebenen Namen und schreibe den generierten Text in die Datei.

    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ecx, 0
        mov esi, 0
        mov ecx, len
        
        for_loop:
        mov al,[text+esi]
        ;cmp [text+esi] cu lit mici
        mov bl, 'a'
        cmp[text+esi], bl
        jb endloop
        mov bl, 'z'
        cmp[text+esi], bl
        ja endloop
        
        sub al, 32 ; +0001_0000     'a'-'A'=97-65=32
        mov [text+esi],al
        endloop:
        inc esi
        loop for_loop
      
    ; für open file
        push dword access_mode
        push dword file_name
        call [fopen]    ;im eax liegt der file_descriptor
        add esp, 4*2
    
        mov [file_descriptor], eax
        ; eax=0 -> nicht richtig geöffnet
        cmp eax, 0
        je final
        
        push dword text
        push dword [file_descriptor]
        call [fprintf]
        add esp, 4*2
        
    ;für close file
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
        final:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
