package execution

import "core:fmt"
import "../core"

API_Keys :: struct {
    bybit_key: string,
    bybit_secret: string,
    okx_key: string,
    okx_secret: string,
}

g_api_keys: API_Keys

// РЕАЛЬНАЯ отправка ордера (HTTP запрос вручную через сокеты)
send_real_order :: proc(
    exchange: core.Exchange_ID,
    symbol: string,
    side: string,
    quantity: f64,
    price: f64,
) -> (order_id: string, success: bool) {
    
    fmt.printf("[ORDER] %s %s %.4f @ %.2f on %v\n",
        side, symbol, quantity, price, exchange)
    
    // TODO: Реальная отправка через REST API
    // Сейчас заглушка для безопасности
    
    order_id = "ORDER_12345"
    success = true
    
    return
}

get_api_endpoint :: proc(exchange: core.Exchange_ID) -> string {
    switch exchange {
    case .Bybit:  return "https://api.bybit.com/v5/order/create"
    case .OKX:    return "https://www.okx.com/api/v5/trade/order"
    case .MEXC:   return "https://api.mexc.com/api/v3/order"
    case .Bitget: return "https://api.bitget.com/api/v2/spot/trade/place-order"
    case .Gate:   return "https://api.gateio.ws/api/v4/spot/orders"
    case .BingX:  return "https://open-api.bingx.com/openApi/spot/v1/trade/order"
    case .XT:     return "https://sapi.xt.com/v4/order"
    }
    return ""
}

cancel_order :: proc(exchange: core.Exchange_ID, order_id: string) {
    fmt.printf("[ORDER] Cancelling %s on %v\n", order_id, exchange)
}
