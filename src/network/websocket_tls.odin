package network

import "core:fmt"
import "core:time"
import "core:thread"
import "../core"

// WebSocket с TLS поддержкой
connect_and_stream_tls :: proc(exchange: core.Exchange_ID, buffer: []byte) {
    host, port := get_ws_endpoint(exchange)
    
    // Подключаемся через TLS
    tls_socket, ok := connect_tls(host, port)
    if !ok {
        fmt.printf("[WS ERROR] TLS connection failed for %v\n", exchange)
        return
    }
    defer tls_close(&tls_socket)
    
    fmt.printf("[WS] TLS connected to %s:%d (%v)\n", host, port, exchange)
    
    // WebSocket handshake
    send_ws_handshake(&tls_socket, host)
    
    // Основной цикл чтения
    for {
        n := tls_recv(&tls_socket, buffer)
        if n <= 0 do break
        
        // Парсим данные
        bid, ask, volume, parsed := parse_ticker_fast(buffer[:n])
        
        if parsed {
            update_live_price(exchange, "BTCUSDT", bid, ask, volume)
        }
    }
}

send_ws_handshake :: proc(socket: ^TLS_Socket, host: string) {
    handshake := fmt.tprintf(
        "GET /ws HTTP/1.1\r\n" +
        "Host: %s\r\n" +
        "Upgrade: websocket\r\n" +
        "Connection: Upgrade\r\n" +
        "Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r\n" +
        "Sec-WebSocket-Version: 13\r\n\r\n",
        host)
    
    tls_send(socket, transmute([]byte)handshake)
}

update_live_price :: proc(exchange: core.Exchange_ID, symbol: string, bid, ask, volume: f64) {
    key := fmt.tprintf("%v_%s", exchange, symbol)
    g_live_prices[key] = Live_Price{
        symbol = symbol,
        exchange = exchange,
        bid = bid,
        ask = ask,
        volume = volume,
        last_update = time.now(),
    }
}
