// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [:]
    )
#endif

let package = Package(
    name: "KNUTICE",
    dependencies: [
        // Add your own dependencies here:
        // .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
        
        .package(
            url: "https://github.com/Alamofire/Alamofire.git",
            from: "5.12.0"
        ),
        .package(
            url: "https://github.com/ReactiveX/RxSwift.git",
            from: "6.10.2"
        ),
        .package(
            url: "https://github.com/hmlongco/Factory.git",
            from: "3.4.0"
        ),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "12.19.2"
        ),
        .package(
            url: "https://github.com/onevcat/Kingfisher",
            from: "8.11.0"
        ),
        .package(
            url: "https://github.com/RxSwiftCommunity/RxDataSources",
            from: "5.0.2"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            from: "1.26.2"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-sharing.git",
            from: "2.10.1"
        ),
        .package(
            url: "https://github.com/SnapKit/SnapKit.git",
            from: "5.7.1"
        ),
        .package(
            url: "https://github.com/Juanpe/SkeletonView.git",
            from: "1.31.0"
        )
    ]
)
