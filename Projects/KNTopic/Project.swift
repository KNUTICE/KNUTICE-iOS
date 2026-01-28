import ProjectDescription

let infoPlist: [String: Plist.Value] = [:]
let project = Project(
    name: "KNTopic",
    targets: [
        .target(
            name: "KNTopic",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.fx.KNTopic",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "KNNetwork", path: "../KNNetwork"),
                .project(target: "KNUtility", path: "../KNUtility"),
                .project(target: "KNDesignSystem", path: "../KNDesignSystem"),
                .external(name: "ComposableArchitecture"),
                .external(name: "Factory"),
            ],
        )
    ]
)
