// ============================================
// real_types.odin - REAL trading data types
// Production HFT system - Feb 2025
// ============================================

package core

import "core:time"
import win32 "core:sys/windows"

// ==================== REAL TRADING CONSTANTS ====================

// Minimum spreads for entry (REAL numbers from trading)
MIN_SPREAD :: struct {
    BTC_ETH:    f64 = 0.0020,  // 0.20% for BTC/ETH
    TOP_10:     f64 = 0.0030,  // 0.30% for top-10
    TOP_30:     f64 = 0.0040,  // 0.40% for top-30  
    ALTS:       f64 = 0.0060,  // 0.60% for alts
}

// Maximum volumes (percentage of order book liquidity)
MAX_VOLUME_PERCENT :: struct {
    BLACK_SWAN:     f64 = 0.10,  // 10% for black swan
    STAT_ARB:       f64 = 0.03,  // 3% for statistical
    FUNDING_ARB:    f64 = 0.05,  // 5% for funding
    TRIANGULAR:     f64 = 0.01,  // 1% for triangular (dangerous)
}

// REAL exchange withdrawal fees (in BTC) - Feb 2025 rates
WITHDRAWAL_FEES :: struct {
    BINANCE:    f64 = 0.0004,
    OKX:        f64 = 0.0002,
    BYBIT:      f64 = 0.0001,
    BITGET:     f64 = 0.0003,
    KUCOIN:     f64 = 0.0005,
    GATEIO:     f64 = 0.0004,
    MEXC:       f64 = 0.0006,
}

// REAL maker/taker fees (VIP rates) - Feb 2025
MAKER_FEES :: struct {
    BINANCE:    f64 = 0.0000,  // VIP 0% maker
    OKX:        f64 = 0.0008,
    BYBIT:      f64 = 0.0000,  // 0% with volume
    BITGET:     f64 = 0.0008,
    KUCOIN:     f64 = 0.0010,
    GATEIO:     f64 = 0.0020,
    MEXC:       f64 = 0.0000,
}

TAKER_FEES :: struct {
    BINANCE:    f64 = 0.0010,
    OKX:        f64 = 0.0010,
    BYBIT:      f64 = 0.0010,
    BITGET:     f64 = 0.0010,
    KUCOIN:     f64 = 0.0010,
    GATEIO:     f64 = 0.0020,
    MEXC:       f64 = 0.0010,
}

// ==================== EXCHANGE IDENTIFIERS ====================

// 12 exchanges we support (7 active, 5 reserve)
Exchange_ID :: enum u8 {
    Binance     = 0,
    OKX         = 1,
    Bybit       = 2,
    Bitget      = 3,
    KuCoin      = 4,
    Gateio      = 5,
    MEXC        = 6,
    HTX         = 7,
    CoinEx      = 8,
    Poloniex    = 9,
    Kraken      = 10,
    Bitfinex    = 11,
}

// Risk levels (3-tier system)
Risk_Level :: enum {
    Black_Swan      = 0,  // Tier 1: Maximum confidence
    Statistical     = 1,  // Tier 2: Medium risk
    Funding         = 2,  // Tier 3: High risk
    Triangular      = 3,  // Special: Dangerous
}

// Arbitrage types
Arbitrage_Type :: enum {
    Cross_Exchange      = 0,  // Binance -> OKX
    Triangular          = 1,  // BTC -> ETH -> USDT -> BTC
    Funding_Rate        = 2,  // Long Bybit, short Binance
    Statistical_Mean    = 3,  // Z-score reversion
    Black_Swan_Event    = 4,  // Flash crash / liquidation
    Listing             = 5,  // New coin listing
    DEX_CEX             = 6,  // DEX vs CEX price difference
    Cross_Chain         = 7,  // Different blockchains
    Swap_Arbitrage      = 8,  // Exchange swap prices
}
