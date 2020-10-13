// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Japx",
    platforms: [.macOS(.v10_12), .iOS(.v10)],
    products: [
        .library(
            name: "Japx",
            targets: ["Japx"]),
        .library(
            name: "JapxAlamofire",
            targets: ["JapxAlamofire"]),
        .library(
            name: "JapxCodable",
            targets: ["JapxCodable"]),
        .library(
            name: "JapxCodableAlamofire",
            targets: ["JapxCodableAlamofire"]),
        .library(
            name: "JapxCodableMoya",
            targets: ["JapxCodableMoya"]),
        .library(
            name: "Japx",
            targets: ["Japx"]),
        .library(
            name: "JapxMoya",
            targets: ["JapxMoya"]),
        .library(
            name: "JapxObjC",
            targets: ["JapxObjC"]),
        .library(
            name: "JapxRxAlamofire",
            targets: ["JapxRxAlamofire"]),
        .library(
            name: "JapxRxCodableAlamofire",
            targets: ["JapxRxCodableAlamofire"]),
        .library(
            name: "JapxRxCodableMoya",
            targets: ["JapxRxCodableMoya"]),
        .library(
            name: "JapxRxMoya",
            targets: ["JapxRxMoya"]),
        .library(
            name: "JapxObjC",
            targets: ["JapxObjC"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "5.1.0")),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "14.0.0"))
    ],
    targets: [
        .target(
            name: "Japx",
            path: "Japx/Classes/Core"),
        .target(
            name: "JapxCodable",
            dependencies: ["Japx"],
            path: "Japx/Classes/Codable"),
        .target(
            name: "JapxAlamofire",
            dependencies: ["Japx", "Alamofire"],
            path: "Japx/Classes/Alamofire"),
        .target(
            name: "JapxRxAlamofire",
            dependencies: ["JapxAlamofire", "RxSwift"],
            path: "Japx/Classes/RxAlamofire"),
        .target(
            name: "JapxCodableAlamofire",
            dependencies: ["JapxAlamofire", "JapxCodable"],
            path: "Japx/Classes/CodableAlamofire"),
        .target(
            name: "JapxRxCodableAlamofire",
            dependencies: ["JapxCodableAlamofire", "JapxRxAlamofire"],
            path: "Japx/Classes/RxCodableAlamofire"),
        .target(
            name: "JapxMoya",
            dependencies: ["Japx", "Moya"],
            path: "Japx/Classes/Moya"),
        .target(
            name: "JapxRxMoya",
            dependencies: ["JapxMoya", .product(name: "RxMoya", package: "Moya")],
            path: "Japx/Classes/RxMoya"),
        .target(
            name: "JapxCodableMoya",
            dependencies: ["Japx", "JapxCodable", "JapxMoya"],
            path: "Japx/Classes/CodableMoya"),
        .target(
            name: "JapxRxCodableMoya",
            dependencies: ["Japx", "JapxCodableMoya", "JapxRxMoya"],
            path: "Japx/Classes/RxCodableMoya"),
        .target(
            name: "JapxObjC",
            dependencies: ["Japx"],
            path: "Japx/Classes/ObjC")
    ]
)
