// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Tisander",
    platforms: [
		.iOS(.v15)
		],
    products: [
        .library(
            name: "Tisander",
            targets: ["Tisander"]),
    ],
    dependencies: [ ],
    targets: [
        .target(
            name: "Tisander",
            dependencies: []),
        .testTarget(
            name: "TisanderTests",
            dependencies: ["Tisander"]),
    ]
)
