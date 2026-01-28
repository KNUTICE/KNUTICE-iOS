import ProjectDescription

let infoPlist: [String: Plist.Value] = [:]
let project = Project(
    name: "KNTip",
    targets: [
        .target(
            name: "KNTip",
            destinations: .iOS,
            product: Environment.forPreview.getBoolean(default: false) ? .framework : .staticFramework,
            bundleId: "com.fx.KNTip",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "KNUtility", path: "../KNUtility"),
                .project(target: "KNNetwork", path: "../KNNetwork"),
                .project(target: "UIComponents", path: "../UIComponents"),
                .external(name: "Factory")
            ]
        ),
        .target(
            name: "KNTipTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.fx.KNTip.tests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["KNTipTests/**"],
            dependencies: [
                .project(target: "KNTip", path: "../KNTip"),
            ]
        ),
    ]
)
