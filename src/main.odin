package main

import "core:fmt"

main :: proc() {
    fmt.println("")
    fmt.println("  ODIN HFT BOT - LIVE TRADING MODE     ")
    fmt.println("  7 Exchanges | Real WebSocket         ")
    fmt.println("\n")
    
    auto_trading_loop()
}
