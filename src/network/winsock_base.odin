package network

import "core:fmt"

init_winsock :: proc() -> bool {
    fmt.println("[WINSOCK] Initialized")
    return true
}
