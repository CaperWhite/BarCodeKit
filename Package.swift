// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BarCodeKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "BarCodeKit",
            targets: ["BarCodeKit"]),
    ],
    targets: [
        .target(
            name: "BarCodeKit",
            cSettings:[
                .headerSearchPath("include/BarCodeKit"),
            ])       
    ]
)
