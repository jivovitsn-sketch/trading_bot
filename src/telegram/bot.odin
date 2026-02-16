package telegram

import "core:fmt"

send_trade_notification :: proc(
    exchange1, exchange2: string,
    symbol: string,
    profit: f64,
) {
    fmt.printf("[TELEGRAM] Trade notification: %s %s->%s profit: %.2f\n", 
        symbol, exchange1, exchange2, profit)
}

send_summary_notification :: proc(total_profit: f64, trades_count: int) {
    fmt.printf("[TELEGRAM] Summary: %d trades, total: %.2f\n", 
        trades_count, total_profit)
}
