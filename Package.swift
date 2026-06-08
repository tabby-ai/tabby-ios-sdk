// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Tabby",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Tabby",
            targets: ["Tabby"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Tabby",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "TabbyTests",
            dependencies: ["Tabby"]
        )
    ]
)
