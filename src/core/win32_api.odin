package core

import win "core:sys/windows"
import "core:fmt"

foreign import kernel32 "system:Kernel32.lib"

@(default_calling_convention="stdcall")
foreign kernel32 {
    SetPriorityClass :: proc(handle: win.HANDLE, priority: win.DWORD) -> win.BOOL ---
}

HIGH_PRIORITY_CLASS :: 0x00000080

init_hft_optimizations :: proc() -> bool {
    handle := win.GetCurrentProcess()
    result := SetPriorityClass(handle, HIGH_PRIORITY_CLASS)
    
    if bool(result) {
        fmt.println("[WIN32] HIGH priority class set")
        return true
    } else {
        fmt.println("[WIN32] Warning: Could not set priority")
        return false
    }
}

get_time_us :: proc() -> i64 {
    counter: win.LARGE_INTEGER
    win.QueryPerformanceCounter(&counter)
    
    freq: win.LARGE_INTEGER
    win.QueryPerformanceFrequency(&freq)
    
    return i64((counter * 1_000_000) / freq)
}

set_thread_affinity :: proc(core_id: u32) -> bool {
    thread := win.GetCurrentThread()
    mask := win.DWORD_PTR(1 << core_id)
    result := win.SetThreadAffinityMask(thread, mask)
    
    if result != 0 {
        fmt.printf("[WIN32] Thread pinned to core %d\n", core_id)
        return true
    }
    return false
}
