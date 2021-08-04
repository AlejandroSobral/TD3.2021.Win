USE16
SECTION .init16

%include "inc/processor-flags.h" 
;Start and jump by now

GLOBAL init16
EXTERN entry

EXTERN _gdtr
EXTERN CS_SEL_32
EXTERN start32_launcher
EXTERN __STACK_START_16
EXTERN __STACK_END_16
;EXTERN gdtr_16

%define PORT_A_8042    0x60
%define CTRL_PORT_8042 0x64
%define KEYB_DIS       0xAD
%define KEYB_EN        0xAE
%define READ_OUT_8042  0xD0
%define WRITE_OUT_8042 0xD1


init16:

    test eax,0x0    ;Check uP status
    jne fault_end

    xor eax,eax
    mov cr3,eax         ;Disabhle TLB

    ;Set 16 bits stacks
    mov ax,cs
    mov ds,ax
    mov ax,__STACK_START_16
    mov ss,ax
    mov sp,__STACK_END_16

    ;Disable cache
    mov eax,cr0
    or eax, (X86_CR0_NW | X86_CR0_CD)
    mov cr0,eax
    wbinvd

    %include "./inc/init_video.inc"       ;Init PCI & Video
    o32 lgdt [gdtr_16]

    ;Set Protected Mode
    smsw ax
    or   ax, X86_CR0_PE
    lmsw ax

    jmp dword CS_SEL_32:start32_launcher

    fault_end:
        hlt



;;;;;; SYS16TABLE
%define PORT_A_8042    0x60
%define CTRL_PORT_8042 0x64
%define KEYB_DIS       0xAD
%define KEYB_EN        0xAE
%define READ_OUT_8042  0xD0
%define WRITE_OUT_8042 0xD1




GDT_16:
NULL_SEL_16    equ $-GDT_16
    DQ 0
CS_SEL_16 equ $-GDT_16         
    dw  0xFFFF                 
    dw  0                      
    db  0                      
    db  0x9A                   
    db  0xCF                   
    db  0x00                   

DS_SEL_16 equ $-GDT_16          
    dw  0xFFFF                  
    dw  0                       
    db  0                       
    db  0x92                    
    db  0xCF                    
    db  0x00                    

GDT_16_LENGTH equ $-GDT_16

gdtr_16:                                
       dw  GDT_16_LENGTH - 1                
       dd  GDT_16   