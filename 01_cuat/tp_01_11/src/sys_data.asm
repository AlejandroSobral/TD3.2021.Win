GLOBAL Keyboard_Buffer_Itself
GLOBAL Load_Keyboard_table_Itself
GLOBAL TIMER_COUNTER
GLOBAL Keyboard_counter
GLOBAL Digit_Table_Average
GLOBAL Screen_pointer
GLOBAL Flag_Task_1
GLOBAL PF_error_code
GLOBAL PF_lin_addrs
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
GLOBAL First_time_Flag


;Mem Section
SECTION .TABLE_KEYBOARD
Load_Keyboard_table_Itself resb 190 ;
Keyboard_Buffer_Itself resb 19   ;
Keyboard_counter db 0x00; Count how many keys were pressed

 
SECTION .__DATA__
TIMER_COUNTER dw 0x00
TASK1_COUNTER dw 0x00
TASK2_COUNTER dw 0x00
TASK3_COUNTER dw 0x00
TASK4_COUNTER dw 0x00
SCH_ACTUAL_TASK db 0
SCH_NEXT_TASK db 0
Screen_pointer resb 4; 
Flag_Task_1 db 0x00
PF_error_code resd 1
PF_lin_addrs resd 1
First_time_Flag db 0
STATUS_T1 db 0
STATUS_T2 db 0
STATUS_T3 db 0
STATUS_T4 db 0
TSS_TO_LOAD dd 0
CR3_TO_LOAD dd 0
NEW_STACK resd 48
