# HFT Simulation — Full-Stack Swift 6.0+

A two-part High-Frequency Trading simulation: a SwiftUI exchange client and an ultra-low-latency server node.

## Architecture

```
HFTSimulation/
├── Sources/
│   ├── HFTProtocol/          # Shared: wire format, Adler-32, fixed-point math
│   │   ├── Protocol/         # BinaryProtocol.swift — structs + constants
│   │   └── Math/             # Adler32.swift, FixedPoint.swift
│   ├── HFTClient/            # SwiftUI macOS GUI (Part A)
│   │   ├── App/              # @main entry point
│   │   ├── Views/            # ContentView, Connection, StreamConfig, Telemetry
│   │   ├── ViewModels/       # ExchangeViewModel (@MainActor, MVVM)
│   │   ├── Networking/       # NWConnectionManager (Actor-isolated)
│   │   └── Engine/           # BinaryPackingEngine, TransactionGenerator
│   └── HFTServer/            # Ultra-low-latency backend (Part B)
│       ├── EventLoop/        # KqueueEventLoop (Darwin), EpollEventLoop (Linux)
│       ├── Memory/           # MemoryArena (1 GB mmap), SlabAllocator (lock-free)
│       ├── Network/          # RingBuffer (zero-copy), PacketParser
│       ├── OrderBook/        # OrderBook (LSM/B+ Tree), Adler32SIMD
│       └── Analytics/        # VWAPCalculator (128-bit), LedgerAccumulator
└── Tests/
```

## Build

```bash
# Server (CLI)
swift build -Xswiftc -strict-concurrency=complete

# Client (GUI) — open in Xcode
open HFTSimulation.xcodeproj
```

## Key Constraints (Part B)
- **Forbidden**: `Foundation.Data`, `Dictionary`, `Array`, `Set`, `Double`, `Float`, `malloc`, `free` (after init), `NWConnection`, `DispatchQueue`
- **Memory**: 1 GB `mmap` arena; lock-free slab for 32/64-byte chunks
- **Networking**: `recvmsg` + `iovec` directly into ring buffer
- **Concurrency**: Swift 6 `--strict-concurrency=complete`, zero data-race warnings

## Wire Protocol — v5.0 Summary
| Segment | Size | Notes |
|---|---|---|
| Global Header | 64 B | Magic `HFTX`, version `0x03`, block count |
| Block Header | 12 B | Block ID, N transactions, Adler-32 |
| Transaction Record | 32 B × N | Fixed-point price, bitmask flags, Big-Endian |
