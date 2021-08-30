// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Japx",
    platforms: [.macOS(.v10_12), .iOS(.v10)],
    products: [
        .library(name: "Japx", targets: ["Japx"]),
        .library(name: "AlamofireJapx", targets: ["AlamofireJapx"]),
        .library(name: "RxAlamofireJapx", targets: ["RxAlamofireJapx"]),
        .library(name: "MoyaJapx", targets: ["MoyaJapx"]),
        .library(name: "RxMoyaJapx", targets: ["RxMoyaJapx"])
    ],
    dependencies: [
       .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.0.0")),
       .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.2.0")),
       .package(url: "https://github.com/Moya/Moya.git", .branch("development"))
    ],
    targets: [
        .target(name: "Japx", path: "Japx/Classes/Core"),
        .target(name: "AlamofireJapx", dependencies: ["Japx", "Alamofire"], path: "Japx/Classes/Alamofire"),
        .target(name: "RxAlamofireJapx", dependencies: ["Japx", "Alamofire", "RxSwift"], path: "Japx/Classes/RxAlamofire"),
        .target(name: "MoyaJapx", dependencies: ["Japx", "Moya"], path: "Japx/Classes/Moya"),
        .target(name: "RxMoyaJapx", dependencies: ["Japx", "Moya", "RxSwift"], path: "Japx/Classes/RxMoya")
    ]
)
