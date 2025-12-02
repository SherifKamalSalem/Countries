// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Location",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Location",
            targets: ["Location"]
        ),
    ],
    targets: [
        .target(
            name: "Location"
        ),
    ]
)
