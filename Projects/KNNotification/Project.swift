import ProjectDescription

let infoPlist: [String: Plist.Value] = [:]
let project = Project(
    name: "KNNotification",
    targets: [
        .target(
            name: "KNNotification",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.fx.KNNotification",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            dependencies: []
        )
    ]
)
