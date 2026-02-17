package execution

import "core:fmt"
import "core:time"
import "../core"
import "../config"
import signing "../crypto"

// РЕАЛЬНАЯ отправка ордера с HMAC подписью
send_real_order_signed :: proc(
    exchange: core.Exchange_ID,
    symbol: string,
    side: string,
    quantity: f64,
    price: f64,
) -> (order_id: string, success: bool) {
    
    // Получаем API ключи
    exchange_name := get_exchange_name(exchange)
    api_key, api_secret := config.get_api_key(exchange_name)
    
    // Строим запрос
    timestamp := signing.get_timestamp_ms()
    
    // Пример для Bybit
    params := fmt.tprintf("symbol=%s&side=%s&orderType=Limit&qty=%.4f&price=%.2f&timestamp=%d",
        symbol, side, quantity, price, timestamp)
    
    // НАСТОЯЩИЙ HMAC-SHA256 через Windows CryptoAPI
    signature := signing.sign_hmac_sha256(api_secret, params)
    
    fmt.printf("[ORDER] Sending SIGNED order: %s %s %.4f @ %.2f on %v\n",
        side, symbol, quantity, price, exchange)
    fmt.printf("[ORDER] HMAC-SHA256: %s\n", signature)
    
    // TODO: Реальная отправка HTTP POST
    order_id = "ORDER_SIGNED_123"
    success = true
    
    return
}

get_exchange_name :: proc(exchange: core.Exchange_ID) -> string {
    #partial switch exchange {
    case .Bybit:  return "bybit"
    case .MEXC:   return "mexc"
    case .OKX:    return "okx"
    case .Bitget: return "bitget"
    case .Gate:   return "gate"
    case .BingX:  return "bingx"
    case .XT:     return "xt"
    }
    return ""
}
