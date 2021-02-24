// swift-tools-version:5.3.0

import PackageDescription

let package = Package(
    name: "TrailforksKit",
    products: [
        .library(
            name: "TrailforksKit",
            targets: ["TrailforksKit"]),
    ],
    targets: [
        .target(
            name: "TrailforksKit",
            dependencies: []),
        .testTarget(
          name: "TrailforksKitTests",
          dependencies: ["TrailforksKit"],
          resources: [
            .copy("regions_detailed.json"),
            .copy("regions_error.json"),
            .copy("token.json"),
          ])
    ]
)
