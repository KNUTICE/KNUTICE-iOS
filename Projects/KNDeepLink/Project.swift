import ProjectDescription

let infoPlist: [String: Plist.Value] = [:]
let project = Project(
    name: "KNDeepLink",
    targets: [
        .target(
            name: "KNDeepLink",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.fx.KNDeepLink",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "KNUtility", path: "../KNUtility"),
                .external(name: "Factory")
            ]
        )
    ]
)
