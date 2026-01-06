import ProjectDescription

let infoPlist: [String: Plist.Value] = [:]
let project = Project(
    name: "KNTip",
    targets: [
        .target(
            name: "KNTip",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.fx.KNTip",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "KNUtility", path: "../KNUtility"),
                .project(target: "KNNetwork", path: "../KNNetwork"),
                .external(name: "Factory")
            ]
        )
    ]
)
