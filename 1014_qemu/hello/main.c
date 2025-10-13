// main.c - C 함수 (메시지 출력)
void main() {
    // 0xB8000: x86/x64 환경에서 VGA 텍스트 모드 버퍼의 시작 주소
    volatile char *vga = (volatile char*)0xB8000;
    
    const char *msg = "Hello, QEMU (TGC Emulation) Test!";
    int i;
    
    // 문자열을 VGA 버퍼에 쓴다
    for (i = 0; msg[i] != '\0'; i++) {
        vga[i * 2] = msg[i]; // 문자
        vga[i * 2 + 1] = 0x07; // 속성 (밝은 회색, 검은색 배경)
    }
    
    // main 함수는 리턴하지 않고 무한 루프를 돌게 됩니다.
}