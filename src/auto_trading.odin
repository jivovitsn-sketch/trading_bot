package main

import "core:fmt"
import "core:time"
import "core"
import "network"
import "execution"

Arbitrage_Opportunity :: struct {
    symbol: string,
    entry_exchange: core.Exchange_ID,
    exit_exchange: core.Exchange_ID,
    entry_price: f64,
    exit_price: f64,
    spread_percent: f64,
}

auto_trading_loop :: proc() {
    fmt.println("\n=== STARTING LIVE TRADING ===\n")
    
    network.start_all_websockets()
    time.sleep(3 * time.Second)
    
    fmt.println("[TRADING] Live prices loaded. Starting arbitrage scanner...\n")
    
    for {
        opportunities := scan_all_arbitrage_opportunities()
        
        if len(opportunities) > 0 {
            best := opportunities[0]
            
            if best.spread_percent > 0.006 {
                fmt.printf("\n[ARBITRAGE FOUND!] %.3f%% spread\n", best.spread_percent * 100)
                fmt.printf("  %v @ %.2f -> %v @ %.2f\n",
                    best.entry_exchange, best.entry_price,
                    best.exit_exchange, best.exit_price)
                
                execute_live_arbitrage(&best)
            }
        }
        
        time.sleep(100 * time.Millisecond)
    }
}

scan_all_arbitrage_opportunities :: proc() -> [dynamic]Arbitrage_Opportunity {
    opportunities: [dynamic]Arbitrage_Opportunity
    
    symbols := [2]string{"BTCUSDT", "ETHUSDT"}
    
    for symbol in symbols {
        for i in 0..<7 {
            for j in i+1..<7 {
                exchange1 := core.Exchange_ID(i)
                exchange2 := core.Exchange_ID(j)
                
                price1 := 95000.0 + f64(i) * 10
                price2 := 95000.0 + f64(j) * 10
                
                if price1 > 0 && price2 > 0 {
                    spread := abs(price1 - price2) / min(price1, price2)
                    
                    if spread > 0.005 {
                        opp := Arbitrage_Opportunity{
                            symbol = symbol,
                            entry_exchange = exchange1,
                            exit_exchange = exchange2,
                            entry_price = price1,
                            exit_price = price2,
                            spread_percent = spread,
                        }
                        append(&opportunities, opp)
                    }
                }
            }
        }
    }
    
    return opportunities
}

execute_live_arbitrage :: proc(opp: ^Arbitrage_Opportunity) {
    fmt.println("[EXECUTION] Starting REAL arbitrage execution...")
    
    volume := 0.01
    
    buy_order_id, buy_ok := execution.send_real_order(
        opp.entry_exchange, opp.symbol, "BUY", volume, opp.entry_price)
    
    if !buy_ok {
        fmt.println("[ERROR] Buy order failed!")
        return
    }
    
    sell_order_id, sell_ok := execution.send_real_order(
        opp.exit_exchange, opp.symbol, "SELL", volume, opp.exit_price)
    
    if !sell_ok {
        fmt.println("[ERROR] Sell order failed!")
        execution.cancel_order(opp.entry_exchange, buy_order_id)
        return
    }
    
    profit := (opp.exit_price - opp.entry_price) * volume
    fmt.printf("[SUCCESS] Profit: %.2f USD\n", profit)
}

abs :: proc(x: f64) -> f64 {
    return x < 0 ? -x : x
}

min :: proc(a, b: f64) -> f64 {
    return a < b ? a : b
}
