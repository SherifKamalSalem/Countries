// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Navigation",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Navigation",
            targets: ["Navigation"]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Networking"),
        .package(path: "../Storage"),
        .package(path: "../Location"),
    ],
    targets: [
        .target(
            name: "Navigation",
            dependencies: [
                "Core",
                "Networking",
                "Storage",
                "Location"
            ]
        ),
        .testTarget(
            name: "NavigationTests",
            dependencies: ["Navigation"]
        ),
    ]
)

