import ProjectDescription

let infoPlist: [String: Plist.Value] = [:]
let project = Project(
    name: "KNUtility",
    targets: [
        .target(
            name: "KNUtility",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.fx.KNUtility",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .external(name: "FirebaseMessaging")
            ]
        )
    ]
)
