MEMORY { RAM : ORIGIN = 0x10000000, LENGTH = 0x10000000 }
SECTIONS {
    .text : {
        *(.text)
    } > RAM
    .data : {
        *(.data)
    } > RAM
}
