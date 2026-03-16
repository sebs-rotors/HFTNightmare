// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "HFTSimulation",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "HFTServer", targets: ["HFTServer"]),
        .library(name: "HFTProtocol", targets: ["HFTProtocol"]),
    ],
    targets: [
        // Shared protocol + math library
        .target(
            name: "HFTProtocol",
            path: "Sources/HFTProtocol",
            swiftSettings: [.unsafeFlags(["-strict-concurrency=complete"])]
        ),
        // macOS SwiftUI client (Xcode target — excluded from swift build)
        // Add via Xcode: File → Add Package → local path, target HFTClient
        .target(
            name: "HFTClient",
            dependencies: ["HFTProtocol"],
            path: "Sources/HFTClient",
            swiftSettings: [.unsafeFlags(["-strict-concurrency=complete"])]
        ),
        // Linux/macOS server binary
        .executableTarget(
            name: "HFTServer",
            dependencies: ["HFTProtocol"],
            path: "Sources/HFTServer",
            swiftSettings: [.unsafeFlags(["-strict-concurrency=complete"])]
        ),
    ]
)
