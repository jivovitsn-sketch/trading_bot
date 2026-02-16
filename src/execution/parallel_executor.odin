package execution

import "core:fmt"
import "core:time"
import "core:thread"
import win "core:sys/windows"
import "../core"

Execute_Context :: struct {
    exchange: core.Exchange_ID,
    price: f64,
    volume: f64,
    result_price: f64,
    success: bool,
}

execute_parallel_arbitrage :: proc(entry_price, exit_price, volume: f64) -> bool {
    fmt.println("[PARALLEL] Starting dual execution...")
    
    entry_ctx := Execute_Context{
        exchange = .Bybit,
        price = entry_price,
        volume = volume,
    }
    
    exit_ctx := Execute_Context{
        exchange = .OKX,
        price = exit_price,
        volume = volume,
    }
    
    entry_thread := thread.create(execute_order_thread)
    exit_thread := thread.create(execute_order_thread)
    
    entry_thread.user_args[0] = &entry_ctx
    exit_thread.user_args[0] = &exit_ctx
    
    start := core.get_time_us()
    thread.start(entry_thread)
    thread.start(exit_thread)
    
    thread.join(entry_thread)
    thread.join(exit_thread)
    
    elapsed := core.get_time_us() - start
    
    thread.destroy(entry_thread)
    thread.destroy(exit_thread)
    
    fmt.printf("[PARALLEL] Completed in %d microseconds\n", elapsed)
    
    return entry_ctx.success && exit_ctx.success
}

execute_order_thread :: proc(t: ^thread.Thread) {
    ctx := cast(^Execute_Context)t.user_args[0]
    
    core_id := ctx.exchange == .Bybit ? 0 : 1
    core.set_thread_affinity(u32(core_id))
    
    time.sleep(20 * time.Millisecond)
    
    ctx.result_price = ctx.price
    ctx.success = true
}
