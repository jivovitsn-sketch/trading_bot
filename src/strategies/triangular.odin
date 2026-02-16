package strategies

import "core:fmt"

find_triangular_opportunity :: proc(btc_usd, eth_btc, eth_usd: f64) -> f64 {
    synthetic_eth_usd := btc_usd * eth_btc
    spread := (synthetic_eth_usd - eth_usd) / eth_usd
    
    if spread > 0.005 {
        fmt.printf("[TRIANGULAR] Found opportunity: %.3f%% spread\n", spread * 100)
    }
    
    return spread
}
