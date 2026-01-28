import ProjectDescription

let infoPlist: [String: Plist.Value] = [:]
let project = Project(
    name: "KNSetting",
    targets: [
        .target(
            name: "KNSetting",
            destinations: .iOS,
            product: Environment.forPreview.getBoolean(default: false) ? .framework : .staticFramework,
            bundleId: "com.fx.KNSetting",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "KNReport", path: "../KNReport"),
                .project(target: "KNTopic", path: "../KNTopic"),
                .project(target: "UIComponents", path: "../UIComponents"),
                .external(name: "ComposableArchitecture"),
            ],
        )
    ]
)
