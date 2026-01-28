import ProjectDescription

let infoPlist: [String: Plist.Value] = [:]
let project = Project(
    name: "KNToken",
    targets: [
        .target(
            name: "KNToken",
            destinations: .iOS,
            product: Environment.forPreview.getBoolean(default: false) ? .framework : .staticFramework,
            bundleId: "com.fx.KNToken",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .external(name: "Factory"),
                .external(name: "FirebaseMessaging"),
                .project(target: "KNUtility", path: "../KNUtility"),
                .project(target: "KNNetwork", path: "../KNNetwork")
            ]
        )
    ]
)
