// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "DebugThingsPulseProxy",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15),
        .macOS(.v13),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "DebugThingsPulseProxy", targets: ["DebugThingsPulseProxy"]),
    ],
    dependencies: [
        .package(url: "https://github.com/avgx/DebugThings.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.12.0"),
        .package(url: "https://github.com/kean/Pulse.git", from: "5.2.1")
    ],
    targets: [
        .target(
            name: "DebugThingsPulseProxy",
            dependencies: [
                .product(name: "DebugThings", package: "DebugThings"),
                .product(name: "Pulse", package: "Pulse"),
                .product(name: "Logging", package: "swift-log"),
            ],
            resources: [.copy("PrivacyInfo.xcprivacy")]
        ),
        .testTarget(
            name: "DebugThingsPulseProxyTests",
            dependencies: ["DebugThingsPulseProxy"]
        ),
    ]
)
