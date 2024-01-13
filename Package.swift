// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "curvelib",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "curvelib",
            targets: ["curvelib"]),
    ],
    targets: [
        .binaryTarget(name: "libcurvelib",
                      path: "Sources/libcurvelib/libcurvelib.xcframework"
        ),
        
        .target(name: "lib",
               dependencies: ["libcurvelib"],
                path: "Sources/libcurvelib"
        ),
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "curvelib",
            dependencies: ["lib"]
        ),
        .testTarget(
            name: "curvelibTests",
            dependencies: ["curvelib"]),
    ]
)
