ENTRY(_start)
MEMORY {
    RAM : ORIGIN = 0x10000000, LENGTH = 0x10000000
}
SECTIONS {
    .text 0x10000000 : {
        _start = .;
        *(.text)
    } > RAM
    .data : {
        *(.data)
    } > RAM
}
