.global _start
.section .text
.code64

_start:
    # 스택 설정
    movq $stack_top, %rsp

    # VGA 메모리에 1바이트 문자 (movb)와 1바이트 색상 (movb) 출력
    movb $0x48, (%rdi)        # 'H'
    movb $0x07, 1(%rdi)       # 색상 (회색)

    # 무한 루프
1:  hlt
    jmp 1b

.section .bss
.align 16
stack_bottom:
.fill 1024, 1, 0
stack_top:
