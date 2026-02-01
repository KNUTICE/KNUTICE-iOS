import ProjectDescription

let infoPlist: [String: Plist.Value] = [:]
let project = Project(
    name: "KNIntelligence",
    targets: [
        .target(
            name: "KNIntelligence",
            destinations: .iOS,
            product: Environment.forPreview.getBoolean(default: false) ? .framework : .staticFramework,
            bundleId: "com.fx.KNIntelligence",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "KNNetwork", path: "../KNNetwork"),
                .project(target: "KNUtility", path: "../KNUtility"),
                .project(target: "KNDesignSystem", path: "../KNDesignSystem"),
                .project(target: "KNMarkdown", path: "../KNMarkdown"),
                .external(name: "ComposableArchitecture"),
                .external(name: "Factory"),
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "6.0",
                    "SWIFT_STRICT_CONCURRENCY": "complete",
                ]
            )
        )
    ]
)
