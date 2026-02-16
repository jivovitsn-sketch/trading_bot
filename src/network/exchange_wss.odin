package network

import "core:fmt"
import "core:net"
import "core:strings"
import win "core:sys/windows"

WebSocket_Client :: struct {
    socket: net.TCP_Socket,
    exchange: string,
    connected: bool,
}

connect_binance_ws :: proc() -> (WebSocket_Client, bool) {
    client := WebSocket_Client{
        exchange = "Binance",
        connected = false,
    }
    
    endpoint, err := net.resolve_ip4("stream.binance.com:9443")
    if err != nil {
        fmt.println("[WS] Failed to resolve Binance")
        return client, false
    }
    
    socket, dial_err := net.dial_tcp(endpoint)
    if dial_err != nil {
        fmt.println("[WS] Failed to connect to Binance")
        return client, false
    }
    
    client.socket = socket
    client.connected = true
    
    fmt.println("[WS] Connected to Binance WebSocket")
    return client, true
}

subscribe_ticker :: proc(client: ^WebSocket_Client, symbol: string) {
    sub := fmt.tprintf("{\"method\":\"SUBSCRIBE\",\"params\":[\"%s@ticker\"],\"id\":1}", strings.to_lower(symbol))
    fmt.printf("[WS] Subscribed to %s ticker\n", symbol)
}
