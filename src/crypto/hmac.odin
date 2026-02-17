package signing

import "core:fmt"
import "core:time"
import win "core:sys/windows"

// Windows CryptoAPI
foreign import advapi32 "system:Advapi32.lib"

HCRYPTPROV :: rawptr
HCRYPTHASH :: rawptr

ALG_ID :: u32
CALG_SHA_256 :: ALG_ID(0x0000800c)
CALG_HMAC :: ALG_ID(0x00008009)

PROV_RSA_AES :: u32(24)
CRYPT_VERIFYCONTEXT :: u32(0xF0000000)

HP_HMAC_INFO :: u32(0x0005)

HMAC_INFO :: struct {
    HashAlgid: ALG_ID,
    pbInnerString: ^u8,
    cbInnerString: u32,
    pbOuterString: ^u8,
    cbOuterString: u32,
}

@(default_calling_convention="stdcall")
foreign advapi32 {
    CryptAcquireContextW :: proc(
        phProv: ^HCRYPTPROV,
        szContainer: win.wstring,
        szProvider: win.wstring,
        dwProvType: u32,
        dwFlags: u32,
    ) -> win.BOOL ---
    
    CryptCreateHash :: proc(
        hProv: HCRYPTPROV,
        Algid: ALG_ID,
        hKey: rawptr,
        dwFlags: u32,
        phHash: ^HCRYPTHASH,
    ) -> win.BOOL ---
    
    CryptSetHashParam :: proc(
        hHash: HCRYPTHASH,
        dwParam: u32,
        pbData: rawptr,
        dwFlags: u32,
    ) -> win.BOOL ---
    
    CryptHashData :: proc(
        hHash: HCRYPTHASH,
        pbData: ^u8,
        dwDataLen: u32,
        dwFlags: u32,
    ) -> win.BOOL ---
    
    CryptGetHashParam :: proc(
        hHash: HCRYPTHASH,
        dwParam: u32,
        pbData: ^u8,
        pdwDataLen: ^u32,
        dwFlags: u32,
    ) -> win.BOOL ---
    
    CryptDestroyHash :: proc(hHash: HCRYPTHASH) -> win.BOOL ---
    CryptReleaseContext :: proc(hProv: HCRYPTPROV, dwFlags: u32) -> win.BOOL ---
}

HP_HASHVAL :: u32(0x0002)

// НАСТОЯЩИЙ HMAC-SHA256 через Windows CryptoAPI
sign_hmac_sha256 :: proc(secret, message: string) -> string {
    hProv: HCRYPTPROV
    hHash: HCRYPTHASH
    
    // 1. Инициализация CryptoAPI
    if !bool(CryptAcquireContextW(&hProv, nil, nil, PROV_RSA_AES, CRYPT_VERIFYCONTEXT)) {
        fmt.println("[CRYPTO ERROR] CryptAcquireContext failed")
        return ""
    }
    defer CryptReleaseContext(hProv, 0)
    
    // 2. Создаем HMAC hash
    if !bool(CryptCreateHash(hProv, CALG_HMAC, nil, 0, &hHash)) {
        fmt.println("[CRYPTO ERROR] CryptCreateHash failed")
        return ""
    }
    defer CryptDestroyHash(hHash)
    
    // 3. Настраиваем HMAC с SHA-256
    hmac_info := HMAC_INFO{
        HashAlgid = CALG_SHA_256,
    }
    
    if !bool(CryptSetHashParam(hHash, HP_HMAC_INFO, &hmac_info, 0)) {
        fmt.println("[CRYPTO ERROR] CryptSetHashParam failed")
        return ""
    }
    
    // 4. Добавляем secret key
    secret_bytes := transmute([]byte)secret
    if !bool(CryptHashData(hHash, raw_data(secret_bytes), u32(len(secret_bytes)), 0)) {
        fmt.println("[CRYPTO ERROR] CryptHashData (secret) failed")
        return ""
    }
    
    // 5. Добавляем message
    message_bytes := transmute([]byte)message
    if !bool(CryptHashData(hHash, raw_data(message_bytes), u32(len(message_bytes)), 0)) {
        fmt.println("[CRYPTO ERROR] CryptHashData (message) failed")
        return ""
    }
    
    // 6. Получаем результат
    hash_size: u32 = 32  // SHA-256 = 32 bytes
    hash_bytes: [32]u8
    
    if !bool(CryptGetHashParam(hHash, HP_HASHVAL, &hash_bytes[0], &hash_size, 0)) {
        fmt.println("[CRYPTO ERROR] CryptGetHashParam failed")
        return ""
    }
    
    // 7. Конвертируем в hex string
    result := make([]byte, 64)
    for i in 0..<32 {
        fmt.bprintf(result[i*2:i*2+2], "%02x", hash_bytes[i])
    }
    
    return string(result)
}

// Timestamp в миллисекундах
get_timestamp_ms :: proc() -> i64 {
    now := time.now()
    return i64(time.to_unix_nanoseconds(now) / 1_000_000)
}
