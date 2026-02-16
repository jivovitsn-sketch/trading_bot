package engine

import "core:fmt"
import "core:math"
import "../core"

Microstructure_Analysis :: struct {
    ofi: f64,
    spread_bps: f64,
    liquidity_score: f64,
    manipulation_score: f64,
}

calculate_vwap_advanced :: proc(prices: []f64, volumes: []f64, depth: int) -> f64 {
    if len(prices) == 0 do return 0
    
    weighted_sum: f64 = 0
    total_volume: f64 = 0
    
    max_depth := min(len(prices), depth)
    
    for i in 0..<max_depth {
        weight := math.exp(-f64(i) * 0.1)
        weighted_sum += prices[i] * volumes[i] * weight
        total_volume += volumes[i] * weight
    }
    
    if total_volume == 0 do return 0
    return weighted_sum / total_volume
}

calculate_order_flow_imbalance :: proc(bid_volumes: []f64, ask_volumes: []f64) -> f64 {
    total_bid: f64 = 0
    total_ask: f64 = 0
    
    for i in 0..<min(len(bid_volumes), 10) {
        total_bid += bid_volumes[i]
        total_ask += ask_volumes[i]
    }
    
    if total_bid + total_ask == 0 do return 0
    return (total_bid - total_ask) / (total_bid + total_ask)
}

analyze_microstructure :: proc(bid_volumes, ask_volumes: []f64) -> Microstructure_Analysis {
    analysis := Microstructure_Analysis{}
    
    analysis.ofi = calculate_order_flow_imbalance(bid_volumes, ask_volumes)
    
    total_liquidity: f64 = 0
    for v in bid_volumes do total_liquidity += v
    for v in ask_volumes do total_liquidity += v
    
    analysis.liquidity_score = min(total_liquidity / 1000000, 1.0)
    
    imbalance := math.abs(analysis.ofi)
    analysis.manipulation_score = imbalance > 0.7 ? 0.8 : 0.2
    
    return analysis
}

detect_manipulation :: proc(analysis: ^Microstructure_Analysis) -> bool {
    return analysis.manipulation_score > 0.7
}
