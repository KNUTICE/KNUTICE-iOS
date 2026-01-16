import ProjectDescription

let infoPlist: [String: Plist.Value] = [:]
let project = Project(
    name: "KNNetwork",
    targets: [
        .target(
            name: "KNNetwork",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.fx.KNNetwork",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            dependencies: [
                .external(name: "Alamofire"),
                .external(name: "RxSwift"),
                .external(name: "Factory"),
                .external(name: "FirebaseMessaging"),
            ]
        )
    ]
)
