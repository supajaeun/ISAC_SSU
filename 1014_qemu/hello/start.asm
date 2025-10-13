section .text
bits 64
global _start

_start:
    ; 1. 스택 포인터 설정
    mov rsp, 0x90000
    
    ; 2. C 함수 호출
    extern main
    call main
    
    ; 3. 무한 루프 (프로그램 종료 방지)
.loop:       ; <--- 명확한 로컬 레이블 정의
    hlt      ; CPU halt
    jmp .loop  ; <--- 정의된 레이블로 점프