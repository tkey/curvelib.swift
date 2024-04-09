// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "curvelib.swift",
    platforms: [
        .iOS(SupportedPlatform.IOSVersion.v13), .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "curveSecp256k1",
            targets: ["curveSecp256k1"]),
        
        .library(
            name: "encryption_aes_cbc_sha512",
            targets: ["encryption_aes_cbc_sha512"]),
        .library(name: "curvelibSha3", targets: ["curvelibSha3"]),
        .library(name: "curvelibCommon", targets: ["curvelibCommon"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .binaryTarget(name: "curve_secp256k1",
                      path: "Sources/curve_secp256k1/curve_secp256k1.xcframework"
        ),
        
        .target(name: "curvelib_xc",
            dependencies: ["curve_secp256k1"],
            path: "Sources/curve_secp256k1"
                
        ),
        .target(name: "curvelibCommon",
            path: "Sources/curvelib/common"
        ),
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "curveSecp256k1",
            dependencies: ["curvelib_xc", "curvelibCommon"],
            path: "Sources/curvelib/secp256k1"
        ),
        .target(
            name: "encryption_aes_cbc_sha512",
            dependencies: ["curvelib_xc", "curveSecp256k1", "curvelibCommon"],
            path: "Sources/curvelib/encryption"
        ),
        .target(
            name: "curvelibSha3",
            dependencies: ["curvelib_xc", "curvelibCommon"],
            path: "Sources/curvelib/sha3"
        ),
        .testTarget(
            name: "curvelibTests",
            dependencies: ["curveSecp256k1", "encryption_aes_cbc_sha512", "curvelibSha3"]),
    ]
)
