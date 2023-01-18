// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Roark",
    platforms: [
        .iOS(.v9), .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Roark",
            targets: ["Roark"]),
    ],
    dependencies: [
        .package(name: "RxSwift",
                 url: "https://github.com/ReactiveX/RxSwift.git",
                 .upToNextMajor(from: "6.5.0")
                ),
        .package(name: "RxSwiftExt",
                 url: "https://github.com/RxSwiftCommunity/RxSwiftExt",
                 .upToNextMajor(from: "6.1.0")
                ),
        .package(name: "RxDataSources",
                 url: "https://github.com/RxSwiftCommunity/RxDataSources",
                 .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        .target(
            name: "Rx",
            dependencies: [
                "RxSwift",
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift"),
                "RxDataSources",
                .product(name: "Differentiator", package: "RxDataSources"),
            ]),
        .target(
            name: "RxTesting",
            dependencies: [
                .product(name: "RxTest", package: "RxSwift"),
                .product(name: "RxBlocking", package: "RxSwift")
            ]),
        .target(
            name: "Roark",
            dependencies: [
                "RxSwiftExt",
                .target(name: "Rx")
            ]),
        .testTarget(
            name: "RoarkTests",
            dependencies: [
                "Roark",
                .target(name: "Rx"),
                .target(name: "RxTesting")
            ]),
    ]
)
