package config

// API КЛЮЧИ ДЛЯ ВСЕХ 7 БИРЖ
// ЗАМЕНИ НА СВОИ ПЕРЕД ЗАПУСКОМ!

API_Config :: struct {
    bybit_key: string,
    bybit_secret: string,
    mexc_key: string,
    mexc_secret: string,
    okx_key: string,
    okx_secret: string,
    okx_passphrase: string,
    bitget_key: string,
    bitget_secret: string,
    bitget_passphrase: string,
    gate_key: string,
    gate_secret: string,
    bingx_key: string,
    bingx_secret: string,
    xt_key: string,
    xt_secret: string,
}

// ГЛОБАЛЬНАЯ КОНФИГУРАЦИЯ
g_api_config := API_Config{
    bybit_key = "YOUR_BYBIT_API_KEY",
    bybit_secret = "YOUR_BYBIT_SECRET",
    mexc_key = "YOUR_MEXC_API_KEY",
    mexc_secret = "YOUR_MEXC_SECRET",
    okx_key = "YOUR_OKX_API_KEY",
    okx_secret = "YOUR_OKX_SECRET",
    okx_passphrase = "YOUR_OKX_PASSPHRASE",
    bitget_key = "YOUR_BITGET_API_KEY",
    bitget_secret = "YOUR_BITGET_SECRET",
    bitget_passphrase = "YOUR_BITGET_PASSPHRASE",
    gate_key = "YOUR_GATE_API_KEY",
    gate_secret = "YOUR_GATE_SECRET",
    bingx_key = "YOUR_BINGX_API_KEY",
    bingx_secret = "YOUR_BINGX_SECRET",
    xt_key = "YOUR_XT_API_KEY",
    xt_secret = "YOUR_XT_SECRET",
}

get_api_key :: proc(exchange: string) -> (key, secret: string) {
    switch exchange {
    case "bybit":  return g_api_config.bybit_key, g_api_config.bybit_secret
    case "mexc":   return g_api_config.mexc_key, g_api_config.mexc_secret
    case "okx":    return g_api_config.okx_key, g_api_config.okx_secret
    case "bitget": return g_api_config.bitget_key, g_api_config.bitget_secret
    case "gate":   return g_api_config.gate_key, g_api_config.gate_secret
    case "bingx":  return g_api_config.bingx_key, g_api_config.bingx_secret
    case "xt":     return g_api_config.xt_key, g_api_config.xt_secret
    }
    return "", ""
}
