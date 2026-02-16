package execution

import "core:fmt"
import "../core"

calculate_withdrawal_decision :: proc(amount_usd: f64) -> string {
    if amount_usd < 50000 {
        return "HOLD_ON_EXCHANGE"
    }
    return "WITHDRAW_NOW"
}
