// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DetailGame",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DetailGame",
            targets: ["DetailGame"])
    ],
    dependencies: [
        .package(path: "../Common"),
        .package(url: "https://github.com/Fostahh/MIDE-Core.git", exact: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DetailGame",
            dependencies: [
                "Common",
                .product(name: "Core", package: "mide-core")
            ]
        ),
        .testTarget(
            name: "DetailGameTests",
            dependencies: ["DetailGame"])
    ]
)
