// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Japx",
    platforms: [.macOS(.v10_12), .iOS(.v10)],
    products: [
        .library(
            name: "JapxCore",
            targets: ["JapxCore"]),
        .library(
            name: "JapxCodable",
            targets: ["JapxCodable"]),
        .library(
            name: "JapxAlamofire",
            targets: ["JapxAlamofire"]),
        .library(
            name: "JapxCodableAlamofire",
            targets: ["JapxCodableAlamofire"]),
        .library(
            name: "JapxCodableMoya",
            targets: ["JapxCodableMoya"]),
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
            name: "JapxCore",
            path: "Japx/Classes/Core"),
        .target(
            name: "JapxCodable",
            dependencies: ["JapxCore"],
            path: "Japx/Classes/Codable"),
        .target(
            name: "JapxAlamofire",
            dependencies: ["JapxCore", "Alamofire"],
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
            dependencies: ["JapxCore", "Moya"],
            path: "Japx/Classes/Moya"),
        .target(
            name: "JapxRxMoya",
            dependencies: ["JapxMoya", .product(name: "RxMoya", package: "Moya")],
            path: "Japx/Classes/RxMoya"),
        .target(
            name: "JapxCodableMoya",
            dependencies: ["JapxCore", "JapxCodable", "JapxMoya"],
            path: "Japx/Classes/CodableMoya"),
        .target(
            name: "JapxRxCodableMoya",
            dependencies: ["JapxCore", "JapxCodableMoya", "JapxRxMoya"],
            path: "Japx/Classes/RxCodableMoya"),
        .target(
            name: "JapxObjC",
            dependencies: ["JapxCore"],
            path: "Japx/Classes/ObjC")
    ]
)
