void c_entry() {
    volatile unsigned int *p = (volatile unsigned int *)0x101f1000;
    *p = 'H';  // UART0에 문자 'H' 강제 출력
    while (1); // 무한 루프
}
