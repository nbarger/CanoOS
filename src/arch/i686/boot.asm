
; the purpose of this file is to set up our kernel's program environment,
; as the kernel itself is technically a program. therefore, it needs a stack,
; and a way to call our C definitions. the multiboot is so that we can verify
; that this is a loadable kernel. the code is based on the OSDev wiki's
; entry.

; mb header constants
MBALIGN equ 1<<0
MEMINFO equ 1<<1
MBFLAGS equ MBALIGN | MEMINFO
MAGIC equ 0x1BADB002
CHECKSUM equ -(MAGIC + MBFLAGS)

; multiboot, tells we're a kernel
section .multiboot
align 4
	dd MAGIC
	dd MBFLAGS
	dd CHECKSUM

; setup stack area
section .bss
align 16
stack_bottom:
	resb 16384 ; 16 KiB
stack_top:

; kernel entry
section .text
global _start:function (_start.end - _start)
_start:
	; set stack pointer
	mov esp, stack_top
	
	; call our kernel
	extern kernel_main
	call kernel_main

	; disable interrupts so we can freeze the cpu (it jumps in an infinite loop)
	cli
.hang:	hlt
	jmp .hang
.end:

