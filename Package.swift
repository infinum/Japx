// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Japx",
    platforms: [.macOS(.v10_12), .iOS(.v10)],
    products: [
        .library(name: "Japx", targets: ["Japx"]),
        .library(name: "JapxAlamofire", targets: ["JapxAlamofire"]),
        .library(name: "JapxRxAlamofire", targets: ["JapxRxAlamofire"]),
        .library(name: "JapxMoya", targets: ["JapxMoya"]),
        .library(name: "JapxRxMoya", targets: ["JapxRxMoya"])
    ],
    dependencies: [
       .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.0.0")),
       .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.2.0")),
       .package(url: "https://github.com/Moya/Moya.git", .branch("development"))
    ],
    targets: [
        .target(name: "Japx", path: "Japx/Classes/Core"),
        .target(name: "JapxAlamofire", dependencies: ["Japx", "Alamofire"], path: "Japx/Classes/Alamofire"),
        .target(name: "JapxRxAlamofire", dependencies: ["JapxAlamofire", "RxSwift"], path: "Japx/Classes/RxAlamofire"),
        .target(name: "JapxMoya", dependencies: ["Japx", "Moya"], path: "Japx/Classes/Moya"),
        .target(name: "JapxRxMoya", dependencies: ["JapxMoya", "RxSwift"], path: "Japx/Classes/RxMoya")
    ]
)
