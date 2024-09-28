// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "gbaSample",
    products: [
        .library(
            name: "gbaSample",
            targets: ["gbaSample"]),
    ],
    targets: [
        .target(
            name: "gbaSample")
    ]
)
