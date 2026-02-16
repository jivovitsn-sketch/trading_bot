package network

import "core:fmt"
import "core:net"
import "core:time"
import "core:thread"
import "../core"

g_live_prices: map[string]Live_Price

Live_Price :: struct {
    symbol: string,
    exchange: core.Exchange_ID,
    bid: f64,
    ask: f64,
    volume: f64,
    last_update: time.Time,
}

start_all_websockets :: proc() {
    exchanges := [7]core.Exchange_ID{.Bybit, .MEXC, .OKX, .Bitget, .Gate, .BingX, .XT}
    
    for exch in exchanges {
        t := thread.create(websocket_thread)
        t.user_args[0] = rawptr(uintptr(exch))
        thread.start(t)
        fmt.printf("[WS] Started WebSocket for %v\n", exch)
    }
}

websocket_thread :: proc(t: ^thread.Thread) {
    exchange := core.Exchange_ID(uintptr(t.user_args[0]))
    
    buffer: [4096]byte
    
    for {
        connect_and_stream(exchange, buffer[:])
        time.sleep(5 * time.Second)
    }
}

connect_and_stream :: proc(exchange: core.Exchange_ID, buffer: []byte) {
    host, port := get_ws_endpoint(exchange)
    
    fmt.printf("[WS] Connecting to %s:%d (%v)\n", host, port, exchange)
    time.sleep(1 * time.Second)
    
    for {
        bid, ask, volume, ok := parse_ticker_fast(buffer[:])
        
        if ok {
            key := fmt.tprintf("%v_BTCUSDT", exchange)
            g_live_prices[key] = Live_Price{
                symbol = "BTCUSDT",
                exchange = exchange,
                bid = bid,
                ask = ask,
                volume = volume,
                last_update = time.now(),
            }
        }
        
        time.sleep(1 * time.Second)
    }
}

get_ws_endpoint :: proc(exchange: core.Exchange_ID) -> (string, int) {
    #partial switch exchange {
    case .Bybit:  return "stream.bybit.com", 443
    case .MEXC:   return "wbs.mexc.com", 443
    case .OKX:    return "ws.okx.com", 443
    case .Bitget: return "ws.bitget.com", 443
    case .Gate:   return "api.gateio.ws", 443
    case .BingX:  return "open-api-ws.bingx.com", 443
    case .XT:     return "stream.xt.com", 443
    }
    return "", 0
}

get_all_live_prices :: proc() -> map[string]Live_Price {
    return g_live_prices
}
