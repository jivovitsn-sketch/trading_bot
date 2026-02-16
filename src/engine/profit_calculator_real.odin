package engine

import "core:fmt"
import "../core"

calculate_real_profit :: proc(
    entry_price, exit_price, volume: f64,
    entry_exchange, exit_exchange: core.Exchange_ID,
) -> f64 {
    gross_profit := (exit_price - entry_price) * volume
    
    // Реальные комиссии для 7 бирж
    maker_fee_rate: f64
    taker_fee_rate: f64
    
    switch entry_exchange {
    case .Bybit:  maker_fee_rate = core.FEE_MAKER_BYBIT
    case .MEXC:   maker_fee_rate = core.FEE_MAKER_MEXC
    case .OKX:    maker_fee_rate = core.FEE_MAKER_OKX
    case .Bitget: maker_fee_rate = core.FEE_MAKER_BITGET
    case .Gate:   maker_fee_rate = core.FEE_MAKER_GATE
    case .BingX:  maker_fee_rate = core.FEE_MAKER_BINGX
    case .XT:     maker_fee_rate = core.FEE_MAKER_XT
    }
    
    switch exit_exchange {
    case .Bybit:  taker_fee_rate = core.FEE_TAKER_BYBIT
    case .MEXC:   taker_fee_rate = core.FEE_TAKER_MEXC
    case .OKX:    taker_fee_rate = core.FEE_TAKER_OKX
    case .Bitget: taker_fee_rate = core.FEE_TAKER_BITGET
    case .Gate:   taker_fee_rate = core.FEE_TAKER_GATE
    case .BingX:  taker_fee_rate = core.FEE_TAKER_BINGX
    case .XT:     taker_fee_rate = core.FEE_TAKER_XT
    }
    
    maker_fee := volume * entry_price * maker_fee_rate
    taker_fee := volume * exit_price * taker_fee_rate
    net_profit := gross_profit - maker_fee - taker_fee
    
    return net_profit
}

print_profit_breakdown :: proc(gross, net: f64) {
    fmt.printf("Gross profit: %.2f\n", gross)
    fmt.printf("Net profit: %.2f\n", net)
}
