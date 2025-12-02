// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CountriesListFeature",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
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
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
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
