%include "inc/defines.h" 
section .task02_functions
USE32

GLOBAL TASK2_LABEL

EXTERN SCREEN_POINTER
EXTERN SCREEN_WRITING
EXTERN DIGIT_TABLE_ITSELF
EXTERN __VIDEO_VMA

DATA_TABLE_SIZE EQU 10
VIDEO_BUFFER_ADDR EQU 0x00E80000

TASK2_LABEL:
  
    
    ;; SIMD ADD ! .-.-.-.-.
    xor ecx, ecx
    mov esi, DIGIT_TABLE_ITSELF          ;Data Source        
    mov edi, DIGIT_TABLE_TOTALSUM_TASK2      ;Total Sum           
    mov ebx, DATA_TABLE_SIZE
    pxor mm0, mm0
ADD_T2:
    paddusw qword mm0, [esi]
    add esi, 8                          
    inc ecx
    cmp ecx, ebx
    jne ADD_T2
    movq qword [edi], mm0                ;Store value
    ;; END SIMD ADD .-.-.-.-.
    
    mov esi, __VIDEO_VMA               
    mov edi, DIGIT_TABLE_TOTALSUM_TASK2        
    mov edx, 1                          
    mov ecx, 64                         
    mov eax, SYS_CALL_SCREEN                                    
    int 0x80

TASK_END_L:

    mov eax, SYS_CALL_HALT                 
    int 0x80
    jmp TASK2_LABEL


section .data_02
DIGIT_TABLE_TOTALSUM_TASK2 dq 0   

