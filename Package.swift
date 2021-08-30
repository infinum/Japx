// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Japx",
    platforms: [.macOS(.v10_12), .iOS(.v10)],
    products: [
        .library(
            name: "Japx",
            targets: ["Japx"]
        )
    ],
    dependencies: [
//        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.0.0")),
//        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.2.0")),
//        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "14.0.0"))
    ],
    targets: [
        .target(
            name: "Japx",
            path: "Japx/Classes/Core"
        )
    ]
)
