package core

import "core:fmt"

// ==================== КОНСТАНТЫ ====================

MIN_SPREAD_BTC_ETH :: 0.0020
MIN_SPREAD_TOP_10 :: 0.0030
MIN_SPREAD_TOP_30 :: 0.0040
MIN_SPREAD_ALTS :: 0.0060

MAX_VOLUME_BLACK_SWAN :: 0.10
MAX_VOLUME_STATISTICAL :: 0.03
MAX_VOLUME_FUNDING :: 0.05
MAX_VOLUME_TRIANGULAR :: 0.01

// Стоимость выводов (BTC) - РЕАЛЬНЫЕ биржи
WITHDRAWAL_BYBIT :: 0.0001
WITHDRAWAL_MEXC :: 0.0006
WITHDRAWAL_OKX :: 0.0002
WITHDRAWAL_BITGET :: 0.0003
WITHDRAWAL_GATE :: 0.0004
WITHDRAWAL_BINGX :: 0.0005
WITHDRAWAL_XT :: 0.0005

// Комиссии maker
FEE_MAKER_BYBIT :: 0.0000
FEE_MAKER_MEXC :: 0.0000
FEE_MAKER_OKX :: 0.0008
FEE_MAKER_BITGET :: 0.0008
FEE_MAKER_GATE :: 0.0015
FEE_MAKER_BINGX :: 0.0010
FEE_MAKER_XT :: 0.0010

// Комиссии taker
FEE_TAKER_BYBIT :: 0.0010
FEE_TAKER_MEXC :: 0.0010
FEE_TAKER_OKX :: 0.0010
FEE_TAKER_BITGET :: 0.0010
FEE_TAKER_GATE :: 0.0025
FEE_TAKER_BINGX :: 0.0020
FEE_TAKER_XT :: 0.0020

// ==================== 7 БИРЖ ====================

Exchange_ID :: enum {
    Bybit,      // #1
    MEXC,       // #2
    OKX,        // #3
    Bitget,     // #4
    Gate,       // #5
    BingX,      // #6
    XT,         // #7
}

Risk_Level :: enum {
    Black_Swan,
    Statistical,
    Funding,
    Triangular,
}

Arbitrage_Type :: enum {
    Cross_Exchange,
    Spot_Futures,
    Funding_Rate,
    Triangular,
}

Order_Book :: struct {
    symbol: string,
    best_bid: f64,
    best_ask: f64,
    spread: f64,
}

Trading_Pair :: struct {
    base: string,
    quote: string,
    symbol: string,
}

Arbitrage_Opportunity :: struct {
    id: u64,
    type: Arbitrage_Type,
    risk_level: Risk_Level,
    entry_exchange: Exchange_ID,
    exit_exchange: Exchange_ID,
    volume: f64,
    entry_price: f64,
    exit_price: f64,
    net_profit_usd: f64,
    profit_percent: f64,
}
