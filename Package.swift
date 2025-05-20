// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "miniapp-core-sdk",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v7),
        .macOS(.v11),
        .macCatalyst(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "miniapp-core-sdk",
            targets: ["miniapp-core-sdk", "miniapp_core"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .upToNextMajor(from: "10.4.0")
        ),
        .package(
            url: "https://github.com/getsentry/sentry-cocoa",
            .upToNextMajor(from: "8.32.0")
        ),
        .package(
            url: "https://github.com/apple/swift-atomics.git",
            .upToNextMajor(from: "1.2.0")
        ),
        .package(
            url: "https://github.com/VergeGroup/swift-concurrency-task-manager",
            .upToNextMajor(from: "1.4.0")
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "miniapp-core-sdk",
            dependencies: [
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "Sentry", package: "sentry-cocoa"),
                .product(name: "Atomics", package: "swift-atomics"),
                .product(name: "ConcurrencyTaskManager", package: "swift-concurrency-task-manager")
            ]
        ),
        .testTarget(
            name: "miniapp-core-sdkTests",
            dependencies: ["miniapp-core-sdk"]
        ),
        .binaryTarget(
            name: "miniapp_core",
            path: "./Sources/miniapp_core.xcframework"
        )
    ],
    swiftLanguageModes: [
        .v5
    ]
)
