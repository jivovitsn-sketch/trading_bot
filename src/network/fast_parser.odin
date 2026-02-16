package network

import "core:fmt"
import "core:mem"

// БЫСТРЫЙ парсинг БЕЗ JSON библиотеки (zero allocations)
parse_ticker_fast :: proc(data: []byte) -> (bid, ask, volume: f64, ok: bool) {
    price_idx := find_field_fast(data, "p")
    if price_idx == -1 do return 0, 0, 0, false
    
    bid = parse_f64_from_bytes(data[price_idx:])
    
    ask_idx := find_field_fast(data, "a")
    if ask_idx != -1 {
        ask = parse_f64_from_bytes(data[ask_idx:])
    }
    
    return bid, ask, 0, true
}

// Быстрый поиск подстроки в байтах
find_field_fast :: proc(data: []byte, field: string) -> int {
    field_bytes := transmute([]byte)field
    
    if len(data) < 16 do return naive_search(data, field_bytes)
    
    first_char := field_bytes[0]
    
    // Оптимизированный поиск (компилятор автоматически векторизует)
    for i := 0; i + 32 <= len(data); i += 32 {
        for j in 0..<32 {
            if data[i+j] == first_char {
                if mem.compare(data[i+j:], field_bytes) == 0 {
                    return i + j
                }
            }
        }
    }
    
    return -1
}

naive_search :: proc(data, pattern: []byte) -> int {
    for i in 0..=len(data)-len(pattern) {
        if mem.compare(data[i:i+len(pattern)], pattern) == 0 {
            return i
        }
    }
    return -1
}

// Парсинг f64 напрямую из байтов (zero allocations)
parse_f64_from_bytes :: proc(data: []byte) -> f64 {
    i := 0
    for i < len(data) && (data[i] < '0' || data[i] > '9') && data[i] != '-' {
        i += 1
    }
    
    sign := f64(1)
    if i < len(data) && data[i] == '-' {
        sign = -1
        i += 1
    }
    
    result := f64(0)
    for i < len(data) && data[i] >= '0' && data[i] <= '9' {
        result = result * 10 + f64(data[i] - '0')
        i += 1
    }
    
    if i < len(data) && data[i] == '.' {
        i += 1
        divisor := f64(10)
        for i < len(data) && data[i] >= '0' && data[i] <= '9' {
            result += f64(data[i] - '0') / divisor
            divisor *= 10
            i += 1
        }
    }
    
    return result * sign
}
