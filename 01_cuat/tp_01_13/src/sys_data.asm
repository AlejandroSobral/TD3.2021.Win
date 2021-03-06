GLOBAL KEYBOARD_BUFFER_ITSELF
GLOBAL DIGIT_TABLE_ITSELF
GLOBAL TIMER_COUNTER
GLOBAL KEYBOARD_COUNTER
GLOBAL DIGIT_TABLE_AVERAGE
GLOBAL SCREEN_POINTER
GLOBAL PF_ERROR_CODE
GLOBAL PF_VMA_ADDR
GLOBAL SCH_ACTUAL_TASK
GLOBAL SCH_NEXT_TASK
GLOBAL STATUS_T1
GLOBAL STATUS_T2
GLOBAL STATUS_T3
GLOBAL STATUS_T4
GLOBAL TSS_TO_LOAD 
GLOBAL CR3_TO_LOAD
GLOBAL NEW_STACK
GLOBAL TASK1_COUNTER 
GLOBAL TASK2_COUNTER 
GLOBAL TASK3_COUNTER 
GLOBAL TASK4_COUNTER
GLOBAL FIRST_TIME_SCH_FLAG


;Mem Section
SECTION .TABLE_KEYBOARD
DIGIT_TABLE_ITSELF resb 190 ;
KEYBOARD_BUFFER_ITSELF resb 19   ;
KEYBOARD_COUNTER db 0x00; Count how many keys were pressed

 
SECTION .__DATA__
TIMER_COUNTER dw 0x00
TASK1_COUNTER dw 0x00
TASK2_COUNTER dw 0x00
TASK3_COUNTER dw 0x00
TASK4_COUNTER dw 0x00
SCH_ACTUAL_TASK db 0
SCH_NEXT_TASK db 0
SCREEN_POINTER resb 4; 
PF_ERROR_CODE resd 1
PF_VMA_ADDR resd 1
FIRST_TIME_SCH_FLAG db 0
STATUS_T1 db 0
STATUS_T2 db 0
STATUS_T3 db 0
STATUS_T4 db 0
TSS_TO_LOAD dd 0
CR3_TO_LOAD dd 0
NEW_STACK resd 48
