package execution

import "core:fmt"
import "core:time"
import "../core"

execute_arbitrage :: proc(entry_price, exit_price, volume: f64) -> bool {
    fmt.println("[EXECUTION] Starting arbitrage...")
    fmt.printf("  Entry: %.2f\n", entry_price)
    fmt.printf("  Exit: %.2f\n", exit_price)
    fmt.printf("  Volume: %.4f\n", volume)
    
    time.sleep(50 * time.Millisecond)
    
    fmt.println("[EXECUTION] Trade completed")
    return true
}
