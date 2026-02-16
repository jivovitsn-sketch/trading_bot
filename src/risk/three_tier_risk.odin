package risk

import "core:fmt"

g_position_count: int = 0

init_risk_manager :: proc() {
    g_position_count = 0
    fmt.println("[RISK] Risk manager initialized")
}

check_trade_allowed :: proc(volume_usd: f64) -> bool {
    if g_position_count >= 3 {
        fmt.println("[RISK] Max positions reached")
        return false
    }
    if volume_usd > 100000 {
        fmt.println("[RISK] Position too large")
        return false
    }
    return true
}

open_position :: proc() {
    g_position_count += 1
    fmt.printf("[RISK] Position opened (total: %d)\n", g_position_count)
}

close_position :: proc() {
    if g_position_count > 0 {
        g_position_count -= 1
    }
    fmt.printf("[RISK] Position closed (total: %d)\n", g_position_count)
}
