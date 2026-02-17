package network

import "core:fmt"
import "core:net"
import win "core:sys/windows"

foreign import schannel "system:Secur32.lib"
foreign import crypt "system:Crypt32.lib"

@(default_calling_convention="stdcall")
foreign schannel {
    InitializeSecurityContextW :: proc(
        phCredential: rawptr,
        phContext: rawptr,
        pszTargetName: win.wstring,
        fContextReq: u32,
        Reserved1: u32,
        TargetDataRep: u32,
        pInput: rawptr,
        Reserved2: u32,
        phNewContext: rawptr,
        pOutput: rawptr,
        pfContextAttr: ^u32,
        ptsExpiry: rawptr,
    ) -> i32 ---
}

TLS_Socket :: struct {
    tcp_socket: net.TCP_Socket,
    ssl_context: rawptr,
    handshake_done: bool,
}

// Подключение к WebSocket с TLS
connect_tls :: proc(host: string, port: int) -> (TLS_Socket, bool) {
    socket := TLS_Socket{}
    
    // 1. TCP подключение
    endpoint, err := net.resolve_ip4(fmt.tprintf("%s:%d", host, port))
    if err != nil do return socket, false
    
    tcp_sock, dial_err := net.dial_tcp(endpoint)
    if dial_err != nil do return socket, false
    
    socket.tcp_socket = tcp_sock
    
    fmt.printf("[TLS] Connected to %s:%d\n", host, port)
    
    // 2. TLS handshake через Schannel
    // TODO: Полная реализация TLS handshake
    socket.handshake_done = true
    
    return socket, true
}

// Отправка данных через TLS
tls_send :: proc(socket: ^TLS_Socket, data: []byte) -> int {
    // В продакшене здесь будет шифрование через Schannel
    n, err := net.send_tcp(socket.tcp_socket, data)
    return n
}

// Получение данных через TLS
tls_recv :: proc(socket: ^TLS_Socket, buffer: []byte) -> int {
    // В продакшене здесь будет дешифрование
    n, err := net.recv_tcp(socket.tcp_socket, buffer)
    return n
}

// Закрытие TLS соединения
tls_close :: proc(socket: ^TLS_Socket) {
    net.close(socket.tcp_socket)
}
