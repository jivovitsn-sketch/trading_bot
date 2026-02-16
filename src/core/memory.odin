package core

import "core:mem"
import win32 "core:sys/windows"
import "core:fmt"

ARENA_SIZE :: 64 * 1024 * 1024

Arena :: struct {
    buffer: []byte,
    offset: int,
}

g_arena: Arena

init_global_memory :: proc() -> bool {
    ptr := win32.VirtualAlloc(nil, ARENA_SIZE, win32.MEM_COMMIT | win32.MEM_RESERVE, win32.PAGE_READWRITE)
    if ptr == nil do return false
    g_arena.buffer = mem.slice_ptr(cast(^byte)ptr, ARENA_SIZE)
    fmt.println("[MEMORY] Arena initialized: 64 MB")
    return true
}

arena_alloc :: proc(size: int) -> rawptr {
    if g_arena.offset + size > len(g_arena.buffer) do return nil
    ptr := raw_data(g_arena.buffer[g_arena.offset:])
    g_arena.offset += size
    return ptr
}
