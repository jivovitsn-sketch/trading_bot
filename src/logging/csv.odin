package logging

import "core:fmt"
import "core:os"
import "core:time"

log_trade :: proc(
    timestamp: time.Time,
    symbol: string,
    entry_exchange, exit_exchange: string,
    entry_price, exit_price, volume, profit: f64,
) {
    line := fmt.tprintf("%v,%s,%s,%s,%.2f,%.2f,%.4f,%.2f\n",
        timestamp, symbol, entry_exchange, exit_exchange,
        entry_price, exit_price, volume, profit)
    
    fmt.print(line)
}
