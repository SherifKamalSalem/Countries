// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "CountriesListFeature",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "CountriesListFeature",
            targets: ["CountriesListFeature"]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Networking"),
        .package(path: "../Storage"),
        .package(path: "../Location"),
        .package(path: "../DesignSystem"),
        .package(path: "../Navigation"),
    ],
    targets: [
        .target(
            name: "CountriesListFeature",
            dependencies: [
                "Core",
                "Networking",
                "Storage",
                "Location",
                "DesignSystem",
                "Navigation"
            ]
        ),
        .testTarget(
            name: "CountriesListFeatureTests",
            dependencies: ["CountriesListFeature"]
        ),
    ]
)
