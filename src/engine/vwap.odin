package engine

import "core:fmt"
import "../core"

LOB_DEPTH :: 20

calculate_vwap :: proc(prices: []f64, volumes: []f64) -> f64 {
    if len(prices) == 0 do return 0
    weighted_sum: f64 = 0
    total_volume: f64 = 0
    for i in 0..<min(len(prices), LOB_DEPTH) {
        weighted_sum += prices[i] * volumes[i]
        total_volume += volumes[i]
    }
    if total_volume == 0 do return 0
    return weighted_sum / total_volume
}

calculate_ofi :: proc(bid_volume, ask_volume: f64) -> f64 {
    total := bid_volume + ask_volume
    if total == 0 do return 0
    return (bid_volume - ask_volume) / total
}
