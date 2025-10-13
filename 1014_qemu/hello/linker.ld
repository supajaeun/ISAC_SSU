/* linker.ld - 링커 스크립트 */
ENTRY(_start)
SECTIONS
{
    . = 0x100000; /* 커널 로드 주소 (1MB) */
    .text : { *(.text) }
    .data : { *(.data) }
    .bss : { *(.bss) }
}