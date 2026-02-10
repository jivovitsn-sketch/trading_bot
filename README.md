#  OdinHFT - High Frequency Trading Bot

## Production Trading System

###  Features
- **7+ Exchanges**: Binance, OKX, Bybit, Bitget, KuCoin, Gate.io, MEXC
- **Real Profit Calculation**: All hidden costs included
- **3-Tier Risk Management**: Black Swan, Statistical, Funding
- **Multi-Strategy**: Cross-exchange, Triangular, Funding, Listing arbitrage
- **Windows Optimized**: IOCP, Thread Affinity, Arena allocators

###  Technology Stack
- **Language**: Odin (systems programming)
- **Platform**: Windows 10/11 x64
- **Network**: Windows IOCP Completion Ports
- **Memory**: Arena allocators, zero GC in hot path
- **UI**: Raylib for real-time dashboard

###  Real Trading Constants
- Binance withdrawal: 0.0004 BTC
- OKX funding every 8h: 00:00, 08:00, 16:00 UTC
- Minimum profit after ALL costs: 0.05%
- Black swan max hold time: 30 seconds
- Bybit hidden liquidity: +20% correction

###  Project Structure

Folder PATH listing for volume Windows 11 Volume serial number is 72B8-B84E C:. +---bin +---config +---data |   +---history |   +---market |   \---snapshots +---docs +---logs +---scripts +---shared +---src |   +---core |   +---data |   +---engine |   +---execution |   +---ml |   +---network |   +---risk |   +---strategies |   \---ui +---tests \---vendor

---
*Project created: 02/10/2026 19:58:25*
