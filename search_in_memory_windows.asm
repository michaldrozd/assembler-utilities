; x86 code to find given string "Hello" in operating memory in Windows
.486
.model flat, stdcall
option casemap :none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib
include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib
include \masm32\include\msvcrt.inc
includelib \masm32\lib\msvcrt.lib
    .data
    .code
    start:
        invoke GetModuleHandle, NULL  ; get handle to current process (our program)
        mov hProcess, eax             ; save handle to current process in hProcess variable
        invoke VirtualQueryEx, hProcess, NULL, addr memInfo, sizeof memInfo  ; get information about memory of current process (our program)
        mov baseAddress, memInfo.BaseAddress  ; save base address of memory of current process in baseAddress variable
        mov regionSize, memInfo.RegionSize    ; save size of memory of current process in regionSize variable
        mov eax, baseAddress                  ; move base address of memory of current process to eax register
        mov ebx, regionSize                   ; move size of memory of current process to ebx register
        mov ecx, 0                            ; set ecx register to 0 (we will use it as counter)
        mov edi, 0                            ; set edi register to 0 (we will use it as counter)

    loop1:                                    ; start loop1 label
        cmp ecx, ebx                          ; compare ecx and ebx registers (if ecx is bigger than ebx then jump to end1 label)
        jg end1                               ; jump to end1 label if ecx is bigger than ebx

        invoke ReadProcessMemory, hProcess, eax, addr buffer, sizeof buffer, NULL  ; read memory from current process (our program) and save it in buffer variable
        cmp buffer[0], 'H'                    ; compare first character in buffer variable with 'H' character
        jne next1                             ; jump to next1 label if first character in buffer variable is not 'H'
        cmp buffer[1], 'e'                    ; compare second character in buffer variable with 'e' character...
        jne next1
        cmp buffer[2], 'l'
        jne next1
        cmp buffer[3], 'l'
        jne next1
        cmp buffer[4], 'o'
        jne next1

    found:                                    ; start found label
            ; print address where string was found on screen using wsprintfA function from msvcrt.inc library and save it into outputBuffer variable using outputFormatString format string
            invoke wsprintfA, addr outputBuffer, addr outputFormatString, eax
            ; show message box on screen using MessageBoxA function from user32.inc library and show message from outputBuffer variable using titleString as title for message box and MB_OK flag for type of message box (ok button)
            invoke MessageBoxA, NULL, addr outputBuffer, addr titleString, MB_OK

            inc edi                           ; increment edi register by 1 (we will use it as counter)

    next1:                                    ; start next1 label
            add eax, 1                        ; add 1 to eax register (move pointer by 1 byte forward)
            inc ecx                           ; increment ecx register by 1 (we will use it as counter)
            jmp loop1                         ; jump back to loop1 label and repeat the same procedure again until we find all strings or until we reach the end of memory region for our program's memory space

    end1:                                      ; start end2 label
            ; print number of strings found on screen using wsprintfA function from msvcrt.inc library and save it into outputBuffer2 variable using outputFormatString2 format string
            invoke wsprintfA, addr outputBuffer2, addr outputFormatString2, edi
            ; show message box on screen using MessageBoxA function from user32.inc library and show message from outputBuffer2 variable using titleString2 as title for message box and MB_OK flag for type of message box (ok button)
            invoke MessageBoxA, NULL, addr outputBuffer2 ,addr titleString2 ,MB_OK

    exit:     invoke ExitProcess ,NULL         ;; exit program using ExitProcess function from kernel32.inc library and passing NULL value as parameter for this function call (no error code returned)
end start
