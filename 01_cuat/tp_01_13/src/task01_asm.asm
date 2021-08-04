%include "inc/defines.h" 
;; CHECK P. 101 de los PDF de paginacion
section .task01_functions
USE32

GLOBAL task01
GLOBAL TASK1_LABEL

;Global Variables
EXTERN buffer_Clear
EXTERN KEYBOARD_BUFFER_ITSELF
EXTERN DIGIT_TABLE_ITSELF
EXTERN _64BITS_AVERAGE_FUNC
EXTERN SCREEN_WRITING
EXTERN SCREEN_POINTER
EXTERN __VIDEO_VMA
VIDEO_BUFFER_ADDR EQU 0x00E80000

task01:
TASK1_LABEL:

    push    ebp
    mov     ebp, esp
    push dword DIGIT_TABLE_AVERAGE
    push dword DIGIT_TABLE_ITSELF
    call _64BITS_AVERAGE_FUNC
    leave

    push    ebp
    mov     ebp, esp
    push 64 ;Column
    push 0  ;Row   
    push dword DIGIT_TABLE_AVERAGE     
    push dword __VIDEO_VMA ;SCREEN_POINTER

    ; SYS_CALL_HALT     EQU     0
    ; SYS_CALL_READ     EQU     1
    ; SYS_CALL_WRITE    EQU     2
    ; SYS_CALL_SCREEN   EQU     3

    mov esi, __VIDEO_VMA               
    mov edi, DIGIT_TABLE_AVERAGE        
    mov edx, 0                          
    mov ecx, 64                         
    mov eax, SYS_CALL_SCREEN                                      
    int 0x80   

    mov eax, SYS_CALL_HALT                 
    int 0x80
    jmp TASK1_LABEL



section .data_01
DIGIT_TABLE_AVERAGE resb 19 ;    