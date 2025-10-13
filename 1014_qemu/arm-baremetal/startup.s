.global _start
_start:
    ldr sp, =0x07ffffff    @ 스택 포인터 설정
    bl c_entry
hang:
    b hang
