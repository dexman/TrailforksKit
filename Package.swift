// swift-tools-version:5.3.0

import PackageDescription

let package = Package(
    name: "TrailforksKit",
    platforms: [
        .macOS(.v11),
        .iOS(.v13),
    ],
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
            .copy("report.json"),
            .copy("token.json"),
          ])
    ]
)
